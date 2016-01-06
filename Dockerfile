FROM ubuntu:15.10

RUN apt-get update && apt-get install -y git libgmp10

ENV HOME /app
ENV LANG en_US.UTF-8
RUN locale-gen en_US.UTF-8


# RUN 
# RUN apt-get install -y 


# RUN DEBIAN_FRONTEND=noninteractive apt-get update
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libgmp10 git
# ADD dist/build/yesodweb/yesodweb /app/yesodweb
ADD static /app/static
ADD config /app/config
COPY .stack-work/install/x86_64-linux/nightly-2015-12-14/7.10.2/bin/test-b64-endpt /app/yesodweb

WORKDIR /app
EXPOSE 3332
CMD ["/app/yesodweb"]
