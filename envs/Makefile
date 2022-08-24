DIRECTORY = cd infra
KEYMAN-DIRECTORY = cd keyman

for-local:
	@${DIRECTORY} && \
		ln -fs ../local_provider.tf ./provider.tf && \
		ln -fs ../local_infra_backend.tf ./backend.tf
	@${KEYMAN-DIRECTORY} && \
		ln -fs ../local_provider.tf ./provider.tf && \
		ln -fs ../local_keyman_backend.tf ./backend.tf

for-codebuild:
	@${DIRECTORY} && \
		ln -fs ../provider.tf ./provider.tf && \
		ln -fs ../infra_backend.tf ./backend.tf
	@${KEYMAN-DIRECTORY} && \
		ln -fs ../provider.tf ./provider.tf && \
		ln -fs ../keyman_backend.tf ./backend.tf