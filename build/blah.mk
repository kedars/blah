# The list of all the libraries in the system
b-libs-y :=
b-libs-paths-y :=
# The list of all the programs in the system
b-exec-y := $(exec-y)
b-exec-paths-y := $(foreach l,$(exec-y),./bin/$(l))
# The list of all artifacts to clean
b-clean-y :=
# The list of dependencies
b-deps-y :=


##### Subdirectory Inclusions
define inc_mak 
 d=$(1)
 include $(1)/Makefile
 include build/post-subdir.mk
endef

# Include blah.mk from all the subdirectories and process them
$(foreach dir,$(subdir),$(eval $(call inc_mak,$(dir))))


# Default Target
all: $(b-exec-paths-y)

# Rule for creating an object file
%.o: %.c
	$(AT)$(CC) -o $@  -c ${@:%.o=%.c} -MMD
	@echo " [cc] $@"

-include $(b-deps-y)

# Rule for creating a library
# Given liba
#  - create ./bin/liba.a
#  - from $(liba-objs-y)
define create_lib
  ./bin/$(1).a: $$($(1)-objs-y:%.c=%.o)
	$$(AT)rm -f $$@
	$$(AT)$$(AR) cru $$@ $$^
	@echo " [ar] $$@"
endef

$(foreach l,$(b-libs-y), $(eval $(call create_lib,$(l))))

# Rule for creating a program
# Given myprog
#  - create ./bin/myprog
#  - from $(myprog-objs-y)
#  - add dependency on all the libraries
define create_prog
  ./bin/$(1): $(b-libs-paths-y)
  ./bin/$(1): $$($(1)-objs-y:%.c=%.o)
	$$(AT)$$(CC) -o $$@ $$($(1)-objs-y:%.c=%.o) -Wl,--start-group $$(b-libs-paths-y) -Wl,--end-group
	@echo " [axf] $$@"
endef

$(foreach p,$(b-exec-y), $(eval $(call create_prog,$(p))))

# Rule for clean
#
clean:
	$(AT)rm -f $(b-clean-y) $(b-libs-paths-y)
	@echo "[clean] all"

# Rule for NOISY Output
ifneq ($(NOISY),1)
AT=@
endif
