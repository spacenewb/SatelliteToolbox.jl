# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Helpers for SGP4 algorithm.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export sgp4

"""
    sgp4(Δt, args...; kwargs...)

Function that initialize the SGP4 structure and propagate the orbit until the
time Δt.

# Returns

- The position vector [km].
- The velocity vector [km/s].
- The SGP4 orbit propagator structure (see `Sgp4Propagator`).
"""
function sgp4(Δt, args...; kwargs...)
    sgp4d = sgp4_init(args...; kwargs...)
    r,v   = sgp4!(sgp4d, Δt)
    return r, v, sgp4d
end
