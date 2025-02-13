TARGET=./dist
ARCHS=amd64 386 arm arm64
GOOS=windows linux darwin
PACKAGENAME="github.com/shoeper/kerbrute"

COMMIT=`git rev-parse --short HEAD`
DATE=`date +%m/%d/%y`
GOVERSION=`go version | cut -d " " -f 3`

ifdef VERSION
	VERSION := "$(VERSION)@shoeper/kerbrute"
else
	VERSION := "dev@shoeper/kerbrute"
endif

LDFLAGS="-X ${PACKAGENAME}/util.GitCommit=${COMMIT} \
-X ${PACKAGENAME}/util.BuildDate=${DATE} \
-X ${PACKAGENAME}/util.GoVersion=${GOVERSION} \
-X ${PACKAGENAME}/util.Version=${VERSION} \
"

.PHONY: help windows linux mac all clean

help:           ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

windows: ## Make Windows x86, x64 and ARM Binaries
	@for ARCH in ${ARCHS}; do \
		echo "Building for windows $${ARCH}.." ;\
		GOOS=windows GOARCH=$${ARCH} go build -a -ldflags ${LDFLAGS} -o ${TARGET}/kerbrute_windows_$${ARCH}.exe || exit 1 ;\
	done; \
	echo "Done."

linux: ## Make Linux x86, x64 and ARM Binaries
	@for ARCH in ${ARCHS}; do \
		echo "Building for linux $${ARCH}..." ; \
		GOOS=linux GOARCH=$${ARCH} go build -a -ldflags ${LDFLAGS} -o ${TARGET}/kerbrute_linux_$${ARCH} || exit 1 ;\
	done; \
	echo "Done."

mac: ## Make Darwin (Mac) x86, x64 and ARM Binaries
	@for ARCH in amd64 arm64; do \
		echo "Building for mac $${ARCH}" ; \
		GOOS=darwin GOARCH=$${ARCH} go build -a -ldflags ${LDFLAGS} -o ${TARGET}/kerbrute_darwin_$${ARCH} || exit 1 ;\
	done; \
	echo "Done."

clean: ## Delete any binaries
	@rm -f ${TARGET}/* ; \
	go clean -i -n github.com/shoeper/kerbrute ; \
	echo "Done."

all: ## Make Windows, Linux and Mac Binaries
all: clean windows linux mac
