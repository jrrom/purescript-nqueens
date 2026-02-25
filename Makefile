.PHONY: demo serve addcommit test

CONF := spago.yaml
DEMO := demo
PKG  := nqueens

demo:
	spago bundle -p $(DEMO)

serve: demo
	npx serve docs

addcommit: demo
	git add -A
	git commit -e
	git push origin main

# Publishing pipeline

BUMP ?= patch
SEMVER := $(shell perl -ne 'print $$1 if (/version: (\d+\.\d+\.\d+)/)' $(CONF)) 

define bump-semver
	$(eval \
		NEW_SEMVER := $(shell echo -n $(SEMVER) | perl -F'\.' -lane \
			'if ("$(1)" eq "major") { $$F[0]++; $$F[1]=0; $$F[2]=0; } \
			elsif ("$(1)" eq "minor") { $$F[1]++; $$F[2]=0; } \
			else { $$F[2]++; } \
			print "$$F[0].$$F[1].$$F[2]"') \
	)
endef

publish:
	$(call bump-semver,$(BUMP))
	perl -pi -e 's/$(SEMVER)/$(NEW_SEMVER)/' $(CONF)
	git add -A
	git commit -e
	git tag 'v$(NEW_SEMVER)'
	git push origin main --tags
	spago publish -p $(PKG)
