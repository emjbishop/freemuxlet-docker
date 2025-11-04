# freemuxlet-docker
This Docker container is for running freemuxlet and pre-processing data for freemuxlet.

The image is based on the popscle author's image: https://hub.docker.com/r/cumulusprod/popscle/tags

I installed several tools on top of their image that I need for running [popscle_helper_tools](https://github.com/aertslab/popscle_helper_tools) script commands.

My original pre-processing docker that includes the popscle-helper-tools scripts is here: https://hub.docker.com/r/emjbishop/popscle-helper/tags

**Notes:**

- Linux amd64 architecture
- Using an old version of linux which is past end of life (Debian Buster)

**To-do's for the future:**

- Consider trying to install popscle in an image that uses a current linux distro