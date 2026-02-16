require("luacad")

-- ==========================================
-- Dimensions (Unit: mm)
-- ==========================================
--
local ball_diameter = 42.67
local ball_radius = ball_diameter / 2
local clearance = 0.5 -- Extra space for a loose fit

-- Holder dimensions
-- Note: A pentagon's flat side is closer to the center than its corners.
-- We need the top radius large enough so the ball cut doesn't break the walls.
-- Min radius for wall = (ball_radius + clearance) / cos(36 degrees)
local top_radius = 32 -- Radius of the pyramid's top face
local base_radius = 45 -- Radius of the pyramid's base
local height = 30 -- Height of the stand
local sink_depth = 12 -- How deep the ball sinks into the stand

-- Text dimesions
local text_depth = 0.6

-- ==========================================
-- Geometry Generation
-- ==========================================

-- Pentagonal pyramid base
-- setting the resolution (fn) to 5 to create a pentagon shape
local pyramid = cylinder({
	r1 = base_radius,
	r2 = top_radius,
	h = height,
	center = true,
}):setcirclefragments(5)

-- Create the spherical cutout (the cup)
-- increasing resolution (fn) to 100 for a smooth spherical surface
local cup_cutout = sphere({
	r = ball_radius + clearance,
}):setcirclefragments(100)

-- Position the cutout
-- The pyramid is centered at Z=0, so the top surface is at Z = height/2.
-- We move the sphere up so its bottom penetrates the top surface by `sink_depth`.
-- Sphere Z Center = (Top of Pyramid) + (Sphere Radius) - (Sink Depth)
local sphere_z = (height / 2) + (ball_radius + clearance) - sink_depth

cup_cutout = cup_cutout:translate(0, 0, sphere_z)

-- Subtract the sphere from the pyramid
local holder = pyramid - cup_cutout

-- ==========================================
-- Watermark
-- ==========================================

-- 2D text at origin
local label = text(0, 0, 0, "Designed by Kushal", 2, "Arial", nil, "center", "center", 1.3)

-- Mirror and extrude
-- mirror X so it reads correctly when you look at the bottom of the print
label = label:mirror(1, 0, 0)
local label_3d = label:linear_extrude(text_depth)

-- Position and subtract
-- move text to the very bottom face (Z = -height/2)
label_3d = label_3d:translate(0, 0, -height / 2)

-- subtract the text from the holder
holder = holder - label_3d

-- ==========================================
-- Render
-- ==========================================
--
holder:setcolor("yellow"):export("design.scad")
