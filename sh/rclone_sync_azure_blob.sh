#!/usr/bin/env sh

error() {
	printf "\033[1;31m$* \033[0m\n"
}

info() {
	printf "\033[0;36m$* \033[0m\n"
}

debug() {
	printf "\033[0;38m$* \033[0m\n"
}

info '>> Azure Blob static web host must use standard v2 blob <<'

AZ=`which az`
if [ -n "$AZ" ]; then
	debug "Azure Cli found at $AZ"
	info "Use 'az login' to authorize if rclone fail to authorize."
else
	error "ERROR: Azure Cli not found."
    debug "Download Azure Cli from https://docs.microsoft.com/zh-cn/cli/azure/install-azure-cli "
	exit 1
fi
	

if [ -n "$1" ]; then
	RCLONE_NAME=$1
else
	error "You must sepcify RCLONE_NAME. Use 'rclone config' to config or list."
	exit 1
fi

if [ -n "$2" ]; then
	error "Does not support this container as static web site"
	exit 1
else
	BLOB_CONTAINER='$web'		# azrue blob standard v2 default container for static web host 
	HEXO_GEN="hexo generate"
fi

pushd ~/work/samuelchen.github.io

info "To sync rclone name <$RCLONE_NAME> container <$BLOB_CONTAINER>..."

hexo clean
$HEXO_GEN && rclone check ./public ${RCLONE_NAME}:${BLOB_CONTAINER}
echo "Press [ENTER] to continue. [CTRL] + [C] to break."
read

rclone sync ./public ${RCLONE_NAME}:${BLOB_CONTAINER}

popd



