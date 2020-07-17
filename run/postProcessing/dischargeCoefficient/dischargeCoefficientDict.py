'''-------------------------------*- py -*-------------------------------------
=========                 |
\\      /  F ield         | OpenFOAM: Addition to OpenFOAM v6
 \\    /   O peration     | Website:  https://github.com/StasF1/intakePipe
  \\  /    A nd           | Copyright (C) 2018-2020 Stanislau Stasheuski
   \\/     M anipulation  |
----------------------------------------------------------------------------'''
exec(open('../.././strokeDict').read())
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

# Boundary conditions
U = [
    15, # m/s, inlet speed for design0 case
    12.1409, # m/s, inlet speed for design1 case
    9.9852, # m/s, inlet speed for design2 case
]

# Pipe & valve geometry
d_pipe = 25.688 # mm, minimum diameter of intake pipe (or diameter for the A point)

d_2Pipe = 29.756 # mm, chamfer diameter of valve neck (or diameter for the A1 point)

d_bar = 6.96 # mm, bar diameter ( d_c )

d_1 = 26.782 # mm, valve diameter

d_2 = 29.206 # mm, head valve diameter

theta = 45 # valve chamfer angle

# *************************************************************************** #