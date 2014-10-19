ruby_centos := /Users/Shared/centos
CENTOS65_X86_64 := $(ruby_centos)/CentOS-6.5-x86_64-bin-DVD1.iso

VIRTUALBOX_VERSION = $(shell virtualbox --help | head -n 1 | awk '{print $$NF}')
VMWARE_BOX_FILES := $(wildcard box/vmware/*.box)
VIRTUALBOX_BOX_FILES := $(wildcard box/virtualbox/*.box)
VMWARE_S3_BUCKET := s3://learningchef/vmware9.8.3/
VIRTUALBOX_S3_BUCKET := s3://learningchef/virtualbox$(VIRTUALBOX_VERSION)/
S3_GRANT_ID := id=395536e070ed40ca64c173c16c60677d035e12dabd06298ff923f61e20cf2504
ALLUSERS_ID := uri=http://acs.amazonaws.com/groups/global/AllUsers
AWS_MISCHATAYLOR_PROFILE = mischataylor

upload-s3: upload-s3-vmware upload-s3-virtualbox

upload-s3-vmware:
	@for vmware_box_file in $(VMWARE_BOX_FILES) ; do \
		aws --profile $(AWS_MISCHATAYLOR_PROFILE) s3 cp $$vmware_box_file $(VMWARE_S3_BUCKET) --storage-class REDUCED_REDUNDANCY --grants full=$(S3_GRANT_ID) read=$(ALLUSERS_ID) ; \
	done

upload-s3-virtualbox:
	@for virtualbox_box_file in $(VIRTUALBOX_BOX_FILES) ; do \
		aws --profile $(AWS_MISCHATAYLOR_PROFILE) s3 cp $$virtualbox_box_file $(VIRTUALBOX_S3_BUCKET) --storage-class REDUCED_REDUNDANCY --grants full=$(S3_GRANT_ID) read=$(ALLUSERS_ID) ; \
	done

test-vagrantcloud: test-vagrantcloud-vmware test-vagrantcloud-virtualbox

test-vagrantcloud-vmware:
	@for shortcut_target in $(SHORTCUT_TARGETS) ; do \
		bin/test-vagrantcloud-box.sh learningchef/$$shortcut_target vmware_fusion vmware_desktop $(CURRENT_DIR)/test/*_spec.rb || exit; \
	done

test-vagrantcloud-virtualbox:
	@for shortcut_target in $(SHORTCUT_TARGETS) ; do \
		bin/test-vagrantcloud-box.sh learningchef/$$shortcut_target virtualbox virtualbox $(CURRENT_DIR)/test/*_spec.rb || exit; \
	done
