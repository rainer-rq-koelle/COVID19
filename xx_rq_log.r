# what did I do?
library(workflowr)

# Replace the example text with your information
# this was set already when implenting the ssh key
wflow_git_config(user.name = "Your Name", user.email = "email@domain")

# /cloud/project is given in the nav part of the file viewer
# existing=TRUE accepts other files and does not overwrite
# workflowr acknowledges project name as "project" (not workspace name!)
wflow_start("/cloud/project", existing = TRUE)

# run an initial wflow_build() to have index, about, and license built
wflow_build()
# edit as appropriate and rerun
wflow_build()


# publish changes
# check first
wflow_status()
wflow_view()

wflow_publish(message = "included dashboard dummy")

wflow_git_commit(".","add dashboard")
 