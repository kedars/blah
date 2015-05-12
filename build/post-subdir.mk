# This file will be iteratively included after including every
# Makefile
# This file should santise all variables and reset them to null

# Note: All variables in this file should be defined as immediate
# variables in the blah.mk

# Fix liba-objs-y with the full path to the directory
$(foreach l,$(libs-y),$(eval $(l)-objs-y := $(foreach s,$($(l)-objs-y),$(d)/$(s))))
# Copy the libs-y in a separate collection variable, and nullify libs-y again
b-libs-paths-y += $(foreach l,$(libs-y),./bin/$(l).a)
b-libs-y += $(libs-y)
b-deps-y +=  $(foreach l,$(libs-y),$(foreach s,$($(l)-objs-y),$(s:%.c=%.d)))
b-clean-y += $(foreach l,$(libs-y),$(foreach s,$($(l)-objs-y),$(s:%.c=%.o))) $(b-deps-y)
libs-y=
