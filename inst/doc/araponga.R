## ----include=FALSE------------------------------------------------------------
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

## ----bellbird-frame, echo=FALSE, out.width="80%", fig.cap="Male bare-throated bellbird singing in Brazil."----
knitr::include_graphics("figures/bellbird.png")

## ----bellbird-landmarks-------------------------------------------------------
# Upper jaw tip
x_ut <- 779.1665929
y_ut <- -118.5923004

# Upper jaw left and right base landmarks
x_ubl <- 801.2635377
y_ubl <- -172.4408205
x_ubr <- 758.6076256
y_ubr <- -171.9911809

# Lower jaw tip
x_lt <- 777.9828121
y_lt <- -267.6136455

# Lower jaw left and right base landmarks
x_lbl <- 805.4430586
y_lbl <- -247.8488698
x_lbr <- 752.4028602
y_lbr <- -248.1718717

## ----central-axis-midpoints---------------------------------------------------
# Midpoint of the two upper base landmarks
x_ub <- mean(c(x_ubl, x_ubr))
y_ub <- mean(c(y_ubl, y_ubr))

# Midpoint of the two lower base landmarks
x_lb <- mean(c(x_lbl, x_lbr))
y_lb <- mean(c(y_lbl, y_lbr))

## ----lower-2d-----------------------------------------------------------------
lower_2d <- project2d.from.xy(x_tip = x_lt, y_tip = y_lt,
                              x_base = x_lb, y_base = y_lb,
                              plot = TRUE)

## -----------------------------------------------------------------------------
lower_2d$pitch2d

## ----initially-unconstrained--------------------------------------------------
lower_pitch_unconstrained <- find.pitch(observed2d = lower_2d,
                                        label_error = 1)
lower_pitch_unconstrained
plot.angles(lower_pitch_unconstrained, type = "pitch")

## ----view-elevation-----------------------------------------------------------
measured_elevation <- seq(-10.4, -8.4, by = 0.1)

plot.angles(measured_elevation,
            type = "view_elevation",
            main = "candidate view elevations")

## ----pitch-with-elevation-----------------------------------------------------
lower_pitch_elevation <- find.pitch(observed2d = lower_2d,
                                    label_error = 1,
                                    candidate_view_elevations = measured_elevation)
lower_pitch_elevation
plot.angles(lower_pitch_elevation, type = "pitch")

## ----assumed-yaw--------------------------------------------------------------
assumed_yaw <- -110:-70

plot.angles(assumed_yaw,
            type = "yaw",
            labels = TRUE,
            main = "candidate yaw range")

## ----pitch-with-yaw-----------------------------------------------------------
lower_pitch_direction <- find.pitch(observed2d = lower_2d,
                                    label_error = 1,
                                    candidate_yaws = assumed_yaw,
                                    candidate_view_elevations = measured_elevation)

lower_pitch_direction
plot.angles(lower_pitch_direction, type = "pitch")

## ----physical-length-inputs---------------------------------------------------
physical_length_lower_mm <- c(19, 23) # mm range; central-axis base to tip
distance_m <- c(46.3, 46.9)         # m range; camera to bird

# Camera parameters:
image_width_px <- 1920
focal_length_mm <- 428.4
sensor_width_mm <- 6.17

## ----full-lengths-from-camera-------------------------------------------------
full_length_lower <- full_length.from.camera(
  length_physical = physical_length_lower_mm,
  distance = distance_m * 1000,  # m to mm
  image_width = image_width_px,
  focal_length = focal_length_mm,
  sensor_width = sensor_width_mm
)
full_length_lower

## ----pitch-with-length--------------------------------------------------------
lower_pitch <- find.pitch(observed2d = lower_2d,
                          label_error = 1,
                          full_length = full_length_lower,
                          candidate_yaws = assumed_yaw,
                          candidate_view_elevations = measured_elevation)
plot.angles(lower_pitch, type = "pitch")

## -----------------------------------------------------------------------------
upper_2d <- project2d.from.xy(x_tip = x_ut, y_tip = y_ut,
                              x_base = x_ub, y_base = y_ub)

physical_length_upper_mm <- c(20, 24)

full_length_upper <- full_length.from.camera(length_physical = physical_length_upper_mm,
                                             distance = distance_m * 1000,
                                             image_width = image_width_px,
                                             focal_length = focal_length_mm,
                                             sensor_width = sensor_width_mm)

upper_pitch <- find.pitch(observed2d = upper_2d,
                          label_error = 1,
                          full_length = full_length_upper,
                          candidate_yaws = assumed_yaw,
                          candidate_view_elevations = measured_elevation)


## -----------------------------------------------------------------------------

plot.angles(lower_pitch, "pitch")
plot.angles(upper_pitch, "pitch", add = TRUE)


## -----------------------------------------------------------------------------
gapes <- sort(unique(as.vector(outer(upper_pitch, lower_pitch, "-"))))
gapes

## -----------------------------------------------------------------------------
lower_yaw <- find.yaw(lower_2d,
                      label_error = 1,
                      full_length = full_length_lower,
                      candidate_pitches = -90:20,
                      candidate_view_elevations = measured_elevation)

lower_yaw
plot.angles(lower_yaw, "yaw")

## -----------------------------------------------------------------------------
upper_yaw <- find.yaw(upper_2d,
                      label_error = 1,
                      full_length = full_length_upper,
                      candidate_pitches = -20:90,
                      candidate_view_elevations = measured_elevation)

upper_yaw
plot.angles(upper_yaw, "yaw")

## -----------------------------------------------------------------------------
both_yaw <- intersect(upper_yaw, lower_yaw)
plot.angles(both_yaw, "yaw")

## -----------------------------------------------------------------------------
next_frame_yaw <- -150:-120

## -----------------------------------------------------------------------------
# orange = excluded; blue = retained
trimmed <- trim.yaws(ccw_yaws = both_yaw,
                     cw_yaws = next_frame_yaw,
                     min_sep = 0,
                     max_sep = 90,
                     plot = TRUE)

both_yaw <- trimmed$trimmed_ccw_yaws
next_frame_yaw <- trimmed$trimmed_cw_yaws

## ----eval=FALSE---------------------------------------------------------------
# candidate_view_elevations = -35:-25

## ----eval=FALSE---------------------------------------------------------------
# # Roughly eye-level view
# candidate_view_elevations = -20:20
# 
# # Object mostly facing the camera
# candidate_yaws = -120:-60
# 
# # Object approximately side-on, facing left
# candidate_yaws = c(-179:-160, 160:180)

## ----eval=FALSE---------------------------------------------------------------
# # A structure that cannot point downward
# candidate_pitches = 0:90

