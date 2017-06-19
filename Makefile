
# Redirect to avoid "Command not found" error due to make optimizations.
NODEJS := $(shell command -v node 2> /dev/null)
NPM := $(shell command -v npm 2> /dev/null)
PANDOC := $(shell command -v pandoc 2> /dev/null)

# A temporary wiki needs to be create in order to import tiddlers and
# export them to html (as if they were to be rendered on the browser).
WIKI_NAME := tmp_wiki
TIDDLYWIKI_INFO := $(WIKI_NAME)/tiddlywiki.info

# Intermediate directory where html and metadata files are generated
# using TiddlyWiki.
TW_OUTPUT_DIR := $(WIKI_NAME)/output

# Output directory where final markdown files will be stored.
MARKDOWN_DIR := markdown_tiddlers

TIDDLYWIKI_JS := node_modules/tiddlywiki/tiddlywiki.js
ADD_PLUGIN_JS := scripts/add-plugin.js
SAFE_RENAME_JS := scripts/safe-rename.js
ORIGINAL_TIDDLYWIKI := wiki.html

# This will only return something after make export-html has been run.
HTML_TIDDLERS := $(wildcard $(TW_OUTPUT_DIR)/*.html)
MARKDOWN_TIDDLERS := $(patsubst $(TW_OUTPUT_DIR)/%.html, \
                                $(MARKDOWN_DIR)/%.md, \
                                $(HTML_TIDDLERS))

.PHONY: export-html
export-html : deps pre
	@echo "Exporting all tiddlers from $(ORIGINAL_TIDDLYWIKI) to html"
	$(NODEJS) $(TIDDLYWIKI_JS) $(WIKI_NAME) --load $(ORIGINAL_TIDDLYWIKI) \
        --render [!is[system]] [encodeuricomponent[]addsuffix[.html]] \
        --render [!is[system]] [encodeuricomponent[]addsuffix[.meta]] \
            text/plain $$:/core/templates/tiddler-metadata
	@echo "Renaming all .html and .meta files to safe characters..."
	$(NODEJS) $(SAFE_RENAME_JS) $(TW_OUTPUT_DIR)

.PHONY: deps
deps :
ifndef NODEJS
	@echo "Node is not available. Please install nodejs."
	exit 1
endif
ifndef NPM
	@echo "Npm is not available. Please install npm."
	exit 1
endif
ifndef PANDOC
	@echo "Pandoc is not available. Please install pandoc."
	exit 1
endif
	@echo "Dependencies OK"

.PHONY: pre
pre : $(TIDDLYWIKI_JS) $(TIDDLYWIKI_INFO) $(ORIGINAL_TIDDLYWIKI)
	@echo "Prerequisites OK"

$(ORIGINAL_TIDDLYWIKI) :
	@echo "You must put a copy of your tiddlywiki in ./$(ORIGINAL_TIDDLYWIKI)"
	@echo "Aborting initialization"
	@exit 1

$(TIDDLYWIKI_JS) :
	@echo "Installing TiddlyWiki..."
	$(NPM) install tiddlywiki
 
$(TIDDLYWIKI_INFO) : $(TIDDLYWIKI_JS)
	@echo "Setting up temporary wiki..."
	$(NODEJS) $(TIDDLYWIKI_JS) $(WIKI_NAME) --init empty
	$(NODEJS) $(ADD_PLUGIN_JS) $(TIDDLYWIKI_INFO) tiddlywiki/tw2parser
	$(NODEJS) $(ADD_PLUGIN_JS) $(TIDDLYWIKI_INFO) tiddlywiki/markdown

.PHONY: convert
convert : $(MARKDOWN_DIR) $(MARKDOWN_TIDDLERS)

$(MARKDOWN_DIR) :
	@echo "Creating folder '$(MARKDOWN_DIR)'..."
	mkdir $(MARKDOWN_DIR)

$(MARKDOWN_DIR)/%.md : $(TW_OUTPUT_DIR)/%.html
	@echo "Generating markdown file '$(@F)'..."
	@echo "---" > "$@"
	@cat "$(^:html=meta)" >> "$@"
	@echo "---" >> "$@"
	@$(PANDOC) -f html-native_divs-native_spans -t commonmark \
        --wrap=preserve -o - "$^" >> "$@"

.PHONY: clean
clean :
	rm -r $(WIKI_NAME) $(MARKDOWN_DIR)
