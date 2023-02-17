# Input Variables
url="https://github.com/example/swiftDialog/releases/latest"
type=".pkg"

# Download latest release from Github function
function downloadGit() {
	# Output function variables
	echo "Running function downloadGit with variables:"
	echo "Latest release URL: $1"
	echo "Downloaded file type: $2"
	
	# Port input variables into function variables
	url=$1
	type=$2	
	
	# Convert latest release URL to Github API url
	url=$(echo "$url" | sed 's/github.com/api.github.com\/repos/')
	
	# Get version number (not used)
	version=$(curl -s $url | grep "tag_name" | sed -E 's/.*"([^"]+)".*/\1/')

	# Parse download URL from json output
	download=$(curl -s $url | grep "browser_download_url" | sed -E 's/.*"([^"]+)".*/\1/')

	# Create temporary working directory
	mkdir /tmp/tempdownload/

	# Get downloaded file name
	cd /tmp/tempdownload; curl -LO "$download"
	downloadname=$(ls /tmp/tempdownload)

	# Install downloaded file based on file type
	# Supported file types: .pkg
	case $type in
	.pkg)
		installer -pkg /tmp/tempdownload/$downloadname -target /
		;;
	esac

	# Cleanup temporary directory
	rm -rf /tmp/tempdownload/
}

# Run download latest release function with provided variables
downloadGit $url $type
