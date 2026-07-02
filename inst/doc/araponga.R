## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.align = "center"
)

## ----setup--------------------------------------------------------------------
library(araponga)

## -----------------------------------------------------------------------------
plot.angles(45, type = "pitch")

## -----------------------------------------------------------------------------
plot.angles(-80, type = "yaw")

## -----------------------------------------------------------------------------
plot.angles(-15, type = "view_elevation")

## ----echo=FALSE, out.width="80%", fig.cap="Male bare-throated bellbird singing in Brazil."----
knitr::include_graphics("figures/bellbird.png")

## -----------------------------------------------------------------------------
# upper tip
x_ut <- -718.5216072
y_ut <- -78.5485277

# upper base
x_ub <- -782.5250905
y_ub <- -105.2195211

# lower tip
x_lt <- -689.0089234
y_lt <- -210.4188121

# lower base
x_lb <- -751.2784311
y_lb <- -178.5397719

## -----------------------------------------------------------------------------
upper_p2d <- pitch2d.from.xy(x_ut, y_ut, x_ub, y_ub, plot = TRUE)

## -----------------------------------------------------------------------------
cat(upper_p2d)

## ----eval = FALSE-------------------------------------------------------------
# upper_pitch <- find.pitch(upper_p2d,
#                    candidate_view_elevations = 0,
#                    candidate_yaws = 0,
#                    label_error = 1)

## ----echo = FALSE-------------------------------------------------------------
# "find" functions aren't CRAN-friendly
upper_pitch <- 21:24

## -----------------------------------------------------------------------------
upper_pitch
plot.angles(upper_pitch, "pitch")

## ----eval = FALSE-------------------------------------------------------------
# upper_pitch <- find.pitch(upper_p2d,
#                    label_error = 1)

## ----echo = FALSE-------------------------------------------------------------
upper_pitch <- -89:89

## -----------------------------------------------------------------------------
upper_pitch
plot.angles(upper_pitch, "pitch")

## -----------------------------------------------------------------------------
measured_elevation <- -34.2

plot.angles(measured_elevation,
            type = "view_elevation",
            main = "measured view elevation")

## ----eval = FALSE-------------------------------------------------------------
# upper_pitch <- find.pitch(upper_p2d,
#                    candidate_view_elevations = measured_elevation,
#                    label_error = 1)

## ----echo = FALSE-------------------------------------------------------------
upper_pitch <- -33:41

## -----------------------------------------------------------------------------
upper_pitch
plot.angles(upper_pitch, "pitch")

## -----------------------------------------------------------------------------
assumed_yaw <- -45:0

plot.angles(assumed_yaw,
            type = "yaw",
            labels = TRUE,
            main = "assumed yaw range")

## ----eval = FALSE-------------------------------------------------------------
# upper_pitch <- find.pitch(upper_p2d,
#                    candidate_view_elevations = measured_elevation,
#                    candidate_yaws = assumed_yaw,
#                    label_error = 1)

## ----echo = FALSE-------------------------------------------------------------
upper_pitch <- -8:29

## -----------------------------------------------------------------------------
upper_pitch
plot.angles(upper_pitch, "pitch")

## ----eval = FALSE-------------------------------------------------------------
# lower_p2d <- pitch2d.from.xy(x_lt, y_lt, x_lb, y_lb)
# 
# lower_pitch <- find.pitch(lower_p2d,
#                    candidate_view_elevations = measured_elevation,
#                    candidate_yaws = assumed_yaw,
#                    label_error = 1)

## ----echo = FALSE-------------------------------------------------------------
lower_pitch <- -43:-30

## -----------------------------------------------------------------------------
lower_pitch

## -----------------------------------------------------------------------------
plot.angles(upper_pitch, "pitch")
plot.angles(lower_pitch, "pitch", add = TRUE)

## -----------------------------------------------------------------------------
gapes <- sort(unique(as.vector(outer(upper_pitch, lower_pitch, "-"))))
gapes

## ----eval = FALSE-------------------------------------------------------------
# upper_pitch_paired <- find.pitch(upper_p2d,
#            candidate_view_elevations = measured_elevation,
#            candidate_yaws = assumed_yaw,
#            label_error = 1,
#            paired = TRUE)
# 
# lower_pitch_paired <- find.pitch(lower_p2d,
#            candidate_view_elevations = measured_elevation,
#            candidate_yaws = assumed_yaw,
#            label_error = 1,
#            paired = TRUE)

## ----eval = FALSE-------------------------------------------------------------
# all_yaws <- unique(c(upper_pitch_paired$yaw, lower_pitch_paired$yaw))
# 
# per_yaw_gapes <- NULL
# for(y in all_yaws){
# 
#   rel_upper_pitch <- upper_pitch_paired$pitch[upper_pitch_paired$yaw == y]
#   rel_lower_pitch <- lower_pitch_paired$pitch[lower_pitch_paired$yaw == y]
#   per_yaw_gapes <- c(per_yaw_gapes,
#                      unique(as.vector(outer(rel_upper_pitch, rel_lower_pitch,"-"))))
# }
# 
# per_yaw_gapes <- sort(unique(per_yaw_gapes))

## ----echo = FALSE-------------------------------------------------------------
per_yaw_gapes <- 34:63

## -----------------------------------------------------------------------------
per_yaw_gapes

## ----eval = FALSE-------------------------------------------------------------
# upper_yaw <- find.yaw(upper_p2d,
#            candidate_view_elevations = measured_elevation,
#            candidate_pitches = -20:90,
#            label_error = 1)

## ----echo = FALSE-------------------------------------------------------------
upper_yaw <- c(-64:80, 83:84, 87)

## -----------------------------------------------------------------------------
upper_yaw
plot.angles(upper_yaw, "yaw")

## ----eval = FALSE-------------------------------------------------------------
# lower_yaw <- find.yaw(lower_p2d,
#            candidate_view_elevations = measured_elevation,
#            candidate_pitches = -90:20,
#            label_error = 1)

## ----echo = FALSE-------------------------------------------------------------
lower_yaw <- c(-85, -82, -80:-78, -76:67)

## -----------------------------------------------------------------------------
lower_yaw
plot.angles(lower_yaw, "yaw")

## -----------------------------------------------------------------------------
both_yaw <- intersect(lower_yaw, upper_yaw)
plot.angles(both_yaw, "yaw")

## ----eval = FALSE-------------------------------------------------------------
# upper_yaw_paired <- find.yaw(upper_p2d,
#            candidate_view_elevations = measured_elevation,
#            candidate_pitches = -20:90,
#            label_error = 1,
#            paired = TRUE)
# 
# lower_yaw_paired <- find.yaw(lower_p2d,
#            candidate_view_elevations = measured_elevation,
#            candidate_pitches = -90:20,
#            label_error = 1,
#            paired = TRUE)
# 
# max_gape_per_yaw <- data.frame(yaw = both_yaw,
#                                gape = NA)
# 
# for(i in seq_along(max_gape_per_yaw$yaw)){
#   rel_yaw <- max_gape_per_yaw$yaw[i]
# 
#   rel_upper_pitch <- upper_yaw_paired$pitch[upper_yaw_paired$yaw == rel_yaw]
#   rel_lower_pitch <- lower_yaw_paired$pitch[lower_yaw_paired$yaw == rel_yaw]
# 
#   max_gape_per_yaw$gape[i] <- max(outer(rel_upper_pitch, rel_lower_pitch, "-"))
# }

## ----echo = FALSE-------------------------------------------------------------
max_gape_per_yaw <- data.frame(yaw = both_yaw,
                               gape = 10)

## -----------------------------------------------------------------------------
yaw <- max_gape_per_yaw$yaw[max_gape_per_yaw$gape >= 0]

any(max_gape_per_yaw$gape < 0)

## -----------------------------------------------------------------------------
next_frame_yaw <- -50:90

## -----------------------------------------------------------------------------
# red = excluded; green = retained
trimmed <- trim.yaws(ccw_yaws = yaw,
                     cw_yaws = next_frame_yaw,
                     min_sep = 0,
                     max_sep = 90,
                     plot = TRUE)

yaw <- trimmed$trimmed_ccw_yaws
next_frame_yaw <- trimmed$trimmed_cw_yaws

## -----------------------------------------------------------------------------
# view elevation measured as -30 degrees, allowed ±5 degrees measurement error
candidate_view_elevations = -35:-25

## -----------------------------------------------------------------------------
# camera approximately level with the object
candidate_view_elevations = -20:20

# object approximately side-on facing left
candidate_yaws = c(-160:-179, 160:180)

# object generally facing the camera
candidate_yaws = -120:-60

## -----------------------------------------------------------------------------
# structure cannot realistically point downward
candidate_pitches = 0:90

# lower mandible of a bird opening mostly downward
candidate_pitches = -90:20

