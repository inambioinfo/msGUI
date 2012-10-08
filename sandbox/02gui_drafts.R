library(gWidgets)
options(guiToolkit = "RGtk2")

msGUI_env <- new.env(parent=.GlobalEnv)
assign(x="counter", value=min(m2h$index), pos=msGUI_env)

window <- gwindow("msGUI", visible = FALSE)
notebook <- gnotebook(cont = window)

descr <- glabel(gettext("Nothing yet..."), 
                cont = notebook, label = gettext("Load experiment"))

group <- ggroup(cont = notebook, label = gettext("Chart"))
left_group <- ggroup(cont = group, horizontal = FALSE) 
right_group <- ggroup(cont = group, horizontal = FALSE)

ggraphics(cont = right_group)

previous_button <- gbutton(text=gettext("Previous"), 
                           handler=update_graphic, 
                           action=-1, 
                           cont=left_group)

next_button <- gbutton(text=gettext("Next"), 
                       handler=update_graphic, 
                       action=1,
                       cont=left_group)


update_graphic <- function(h, ...) {
  i <- get("counter", pos=msGUI_env) + h$action
  i <- ifelse(i>0, i, 1)
  assign("counter", i, pos=msGUI_env)
  t <- proc.time()
  plot(m2[[i]]@intensity ~ m2[[i]]@mz, 
       xlab="mz", ylab="intensity", main=paste("Spectrum", i))
  svalue(time) <- paste("Plotting took", round((proc.time()-t)[3], 2), "seconds")
  preload(i)
}

# Let's try simple preloading

#group_two <- ggroup(cont = notebook, label = gettext("Charts with simple preloading"))
#left_group_two <- ggroup(cont = group_two, horizontal = FALSE) 
#right_group_two <- ggroup(cont = group_two, horizontal = FALSE)

#ggraphics(cont = right_group_two)

next_button_two <- gbutton(text=gettext("Next (with preloading)"), 
                       handler=update_graphic_pre, 
                       action=1,
                       cont=left_group)

time <- glabel("", cont = left_group)

assign(x="counter", value=min(m2h$index), pos=msGUI_env)

update_graphic_pre <- function(h, ...) {
  i <- get("counter", pos=msGUI_env) + h$action
  i <- ifelse(i>0, i, 1)
  assign("counter", i, pos=msGUI_env)
  t <- proc.time()
  plot(get("dt", pos=msGUI_env), main=paste("Spectrum", i))
  svalue(time) <- paste("Plotting took", round((proc.time()-t)[3], 2), "seconds")
  preload(i)
}

preload <- function(i) {
  assign("dt", data.frame(mz=m2[[i+1]]@mz, intensity=m2[[i+1]]@intensity), 
         pos=msGUI_env)
}

preload(0)
visible(window) <- TRUE
update_graphic_pre(list(action=0))