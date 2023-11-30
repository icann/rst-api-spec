all:
	gpp rst-api-spec.yaml.in > rst-api-spec.yaml
	gpp -Dinternal rst-api-spec.yaml.in > rst-api-spec-internal.yaml
