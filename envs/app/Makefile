BLUE-DIRECTORY = cd blue
GREEN-DIRECTORY = cd green
FRONT-DIRECTORY = cd front
BLUE-DIRECTORY-NAME = blue

for-local:
	@${BLUE-DIRECTORY} && \
		ln -fs ../../local_provider.tf ./provider.tf && \
		ln -fs ../local_blue_backend.tf ./backend.tf && \
		ln -fs ../local_remotestate.tf ./remotestate.tf
	@${GREEN-DIRECTORY} && \
		ln -fs ../../local_provider.tf ./provider.tf && \
		ln -fs ../local_green_backend.tf ./backend.tf && \
		ln -fs ../local_remotestate.tf ./remotestate.tf
	@${FRONT-DIRECTORY} && \
		ln -fs ../../local_provider.tf ./provider.tf && \
		ln -fs ../local_front_backend.tf ./backend.tf && \
		ln -fs ../local_infra_app_remotestate.tf ./remotestate.tf
	

for-codebuild:
	@${BLUE-DIRECTORY} && \
		ln -fs ../../provider.tf ./provider.tf && \
		ln -fs ../blue_backend.tf ./backend.tf && \
		ln -fs ../remotestate.tf ./remotestate.tf
	@${GREEN-DIRECTORY} && \
		ln -fs ../../provider.tf ./provider.tf && \
		ln -fs ../green_backend.tf ./backend.tf && \
		ln -fs ../remotestate.tf ./remotestate.tf
	@${FRONT-DIRECTORY} && \
		ln -fs ../../provider.tf ./provider.tf && \
		ln -fs ../front_backend.tf ./backend.tf && \
		ln -fs ../infra_app_remotestate.tf ./remotestate.tf

link-blue:
	@${GREEN-DIRECTORY} && \
		ln -fs ../${BLUE-DIRECTORY-NAME}/ec2.tf ./ec2.tf && \
		ln -fs ../${BLUE-DIRECTORY-NAME}/s3.tf ./s3.tf && \
		ln -fs ../${BLUE-DIRECTORY-NAME}/keypair.tf ./keypair.tf && \
		ln -fs ../${BLUE-DIRECTORY-NAME}/variables.tf ./variables.tf