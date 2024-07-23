FROM centos:7

LABEL opensciencegrid.name="EL 7"
LABEL opensciencegrid.description="Enterprise Linux (CentOS) 7 base image"
LABEL opensciencegrid.url="https://www.centos.org/"
LABEL opensciencegrid.category="Base"
LABEL opensciencegrid.definition_url="https://github.com/opensciencegrid/osgvo-el7"


RUN rm -f /etc/yum.repos.d/*

RUN echo -e "[base]\nname=CentOS-$releasever - Base\nbaseurl=https://mirror.kakao.com/centos/7/os/x86_64\ngpgcheck=1\nenabled=1\ngpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7\n#released updates\n[updates]\nname=CentOS-$releasever - Updates\n# original\nbaseurl=http://mirror.kakao.com/centos/7/updates/x86_64\ngpgcheck=1\nenabled=1\ngpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7\n#additional packages that may be useful\n[extras]\nname=CentOS-$releasever - Extras\nbaseurl=http://mirror.kakao.com/centos/7/extras/x86_64\ngpgcheck=0\ngpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7\n#additional packages that extend functionality of existing packages\n[centosplus]\nname=CentOS-$releasever - Plus\nbaseurl=http://mirror.kakao.com/centos/7/centosplus/x86_64\ngpgcheck=1\nenabled=0\ngpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7\n">> /etc/yum.repos.d/CentOS-Base.repo

RUN yum -y upgrade && \
    yum -y install epel-release yum-plugin-priorities && \
    yum -y install http://repo.opensciencegrid.org/osg/3.6/osg-3.6-el7-release-latest.rpm && \
    echo -e "# Pegasus\n[Pegasus]\nname=Pegasus\nbaseurl=http://download.pegasus.isi.edu/wms/download/rhel/7/\$basearch/\ngpgcheck=0\nenabled=1\npriority=50" >/etc/yum.repos.d/pegasus.repo && \
    yum -y groups mark convert && \
    yum -y grouplist &&\
    yum -y groupinstall "Compatibility Libraries" \
                        "Development Tools" \
                        "Scientific Support" && \
    yum -y install --enablerepo=osg-testing \
           astropy-tools \
           bc \
           binutils \
           binutils-devel \
           cmake \
           compat-glibc \
           condor \
           coreutils \
           curl \
           davix-devel \
           dcap-devel \
           doxygen \
           dpm-devel \
           fontconfig \
           gcc \
           gcc-c++ \
           gcc-gfortran \
           git \
           glew-devel \
           glib2-devel \
           glib-devel \
           globus-gass-copy-devel \
           graphviz \
           gsl-devel \
           gtest-devel \
           java-1.8.0-openjdk \
           java-1.8.0-openjdk-devel \
           jq \
           json-c-devel \
           lfc-devel \
           libattr-devel \
           libgfortran \
           libGLU \
           libgomp \
           libicu \
           libquadmath \
           libssh2-devel \
           libtool \
           libtool-ltdl \
           libtool-ltdl-devel \
           libuuid-devel \
           libX11-devel \
           libXaw-devel \
           libXext-devel \
           libXft-devel \
           libxml2 \
           libxml2-devel \
           libXm \
           libXmu-devel \
           libXpm \
           libXpm-devel \
           libXt \
           mesa-libGL-devel \
           motif \
           motif-devel \
           nano \
           numpy \
           octave \
           octave-devel \
           openldap-devel \
           openssh \
           openssh-server \
           openssl098e \
           osg-ca-certs \
           osg-wn-client \
           p7zip \
           p7zip-plugins \
           pegasus \
           python3 \
           python36-PyYAML \
           python3-devel \
           python3-pip \
           python-astropy \
           python-devel \
           R-devel \
           redhat-lsb \
           redhat-lsb-core \
           rsync \
           scipy \
           srm-ifce-devel \
           stashcp \
           subversion \
           tcl-devel \
           tcsh \
           time \
           tk-devel \
           vim \
           wget \
           which \
           xrootd-client-devel \
           zlib-devel
## Custom install
RUN yum install -y parallel
RUN rm -f /etc/grid-security/certificates/*.r0 && \
    yum clean all

# required directories
RUN for MNTPOINT in \
        /cvmfs \
        /ceph \
        /hadoop \
        /hdfs \
        /mnt/hadoop \
        /mnt/hdfs \
        /xenon \
        /scratch \
        /spt \
        /stash2 \
    ; do \
        mkdir -p $MNTPOINT ; \
    done

# make sure we have a way to bind host provided libraries
# see https://github.com/singularityware/singularity/issues/611
RUN mkdir -p /host-libs /etc/OpenCL/vendors

# some extra singularity stuff
COPY .singularity.d /.singularity.d

# build info
RUN echo "Timestamp:" `date --utc` |  tee /image-build-info.txt


