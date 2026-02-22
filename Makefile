.PHONY: demo serve addcommit test

CONF := spago.yaml

demo:
	spago bundle -p demo

serve: demo
	npx serve docs

addcommit: demo
	git add -A
	git commit -m "sync: local version to git" -e
	git push origin main

# Publishing pipeline

BUMP ?= patch
SEMVER := $(shell perl -ne 'print $$1 if (/version: (\d+\.\d+\.\d+)/)' $(CONF)) 

define bump-semver
	$(eval \
		NEW_SEMVER := $(shell echo $(SEMVER) | perl -F'\.' -ane 'print "$${\($$F[0] + $(1))}.$${\($$F[1] + $(2))}.$${\($$F[2] + $(3))}"') \
	)
endef

publish:
ifeq ($(BUMP), patch)
	$(call bump-semver,0,0,1)
else ifeq ($(BUMP), minor)
	$(call bump-semver,0,1,0)
else
	$(call bump-semver,1,0,0)
endif
	perl -nei 's/$(SEMVER)/$(NEW_SEMVER)/'
	git add -A
	git commit -m "bump: new version $(NEW_SEMVER)" -e
	git tag 'v$(NEW_SEMVER)'
	git push origin main --tags

