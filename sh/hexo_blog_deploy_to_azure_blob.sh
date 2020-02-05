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
else
	error "ERROR: Azure Cli not found."
    debug "Download Azure Cli from https://docs.microsoft.com/zh-cn/cli/azure/install-azure-cli "
	exit 1
fi
	

if [ -n "$1" ]; then
	BLOB_ACCOUNT=$1
else
	BLOB_ACCOUNT="chen"			# azure blob account.
fi

if [ -n "$2" ]; then
	error "Does not support this container as static web site"
	exit 1
	BLOB_CONTAINER=$2
	HEXO_GEN="hexo --config _config.azure_blob.yml generate"
	URL="https://${BLOB_ACCOUNT}.z7.web.core.windows.net/${BLOB_CONTAINER}/index.html"
else
	BLOB_CONTAINER='$web'		# azrue blob standard v2 default container for static web host 
	HEXO_GEN="hexo generate"
	URL="https://${BLOB_ACCOUNT}.z7.web.core.windows.net/"
fi


info "Deploy to Azure blob account <$BLOB_ACCOUNT> container <$BLOB_CONTAINER>..."


#--pattern                   : The pattern used for globbing files or blobs in the source. The
#                                  supported patterns are '*', '?', '[seq]', and '[!seq]'.


hexo clean
$HEXO_GEN && az storage blob upload-batch -d $BLOB_CONTAINER --account-name $BLOB_ACCOUNT -s ./public

info "Visit $URL"


