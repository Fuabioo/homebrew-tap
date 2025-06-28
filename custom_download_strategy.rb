require "download_strategy"

# GitHubPrivateRepositoryReleaseDownloadStrategy downloads contents from GitHub
# Private Repository. To use it, add `:using => GitHubPrivateRepositoryReleaseDownloadStrategy` to the URL section of your formula.
# This implementation uses the GITHUB_TOKEN environment variable for authentication.
class GitHubPrivateRepositoryReleaseDownloadStrategy < CurlDownloadStrategy
  require "utils/github"

  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
    set_github_token
  end

  def parse_url_pattern
    unless match = url.match(%r{https://github.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(.+)})
      raise "Invalid GitHub release URL format. Expected: https://github.com/owner/repo/releases/download/tag/filename"
    end

    @owner = match[1]
    @repo = match[2]
    @tag = match[3]
    @filename = match[4]
  end

  def set_github_token
    @github_token = ENV["GITHUB_TOKEN"]
    unless @github_token
      raise <<~EOS
        Download Failed: GITHUB_TOKEN environment variable is required for private repository access.

        To fix this:
        1. Create a Personal Access Token at: https://github.com/settings/tokens
        2. Grant it 'repo' scope for private repository access
        3. Set the environment variable:
           export GITHUB_TOKEN=your_token_here
        4. Add to your shell profile for persistence:
           echo 'export GITHUB_TOKEN=your_token_here' >> ~/.zshrc

        Then try installing again.
      EOS
    end
  end

  def fetch
    ohai "Downloading #{@filename} from private GitHub repository..."

    # Get the asset download URL from GitHub API
    api_url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"

    # First, get the release information
    release_info_args = [
      "--silent",
      "--show-error",
      "--header", "Authorization: token #{@github_token}",
      "--header", "Accept: application/vnd.github.v3+json",
      api_url
    ]

    release_json = Utils.popen_read("curl", *release_info_args)

    if $CHILD_STATUS.exitstatus != 0
      raise "Failed to fetch release information from GitHub API"
    end

    require "json"
    release_data = JSON.parse(release_json)

    # Find the asset with matching filename
    asset = release_data["assets"].find { |a| a["name"] == @filename }
    unless asset
      raise "Asset '#{@filename}' not found in release '#{@tag}'"
    end

    asset_url = asset["url"]

    # Download the asset with proper GitHub API headers
    download_args = [
      "--silent",
      "--show-error",
      "--location",
      "--header", "Authorization: token #{@github_token}",
      "--header", "Accept: application/octet-stream",
      "--output", temporary_path,
      asset_url
    ]

    system_command!("curl", args: download_args, verbose: verbose?)
  end

  def clear_cache
    super
  end
end

# Alias for backward compatibility
GitHubPrivateRepositoryDownloadStrategy = GitHubPrivateRepositoryReleaseDownloadStrategy
