# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#    API implementation for SGP4 orbit propagator.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

get_epoch(orbp::OrbitPropagatorSGP4) = orbp.sgp4d.epoch

function get_mean_elements(orbp::OrbitPropagatorSGP4)
    sgp4d = orbp.sgp4d
    orb = KeplerianElements(
        sgp4d.epoch + sgp4d.Δt / 86400,
        sgp4d.a_k * (1000 * sgp4d.sgp4c.R0),
        sgp4d.e_k,
        sgp4d.i_k,
        sgp4d.Ω_k,
        sgp4d.ω_k,
        M_to_f(sgp4d.e_k, sgp4d.M_k)
    )

    return orb
end

"""
    init_orbit_propagator(Val(:sgp4), tle::TLE,; kwargs...) where T

Initialize the SGP4 orbit propagator using the TLE `tle`.

# Keywords

- `sgp4c::SGP4_GraveCte`: SGP4 propagator constants.
    (**Default** = `sgp4c_wgs84`)
"""
function init_orbit_propagator(
    ::Val{:sgp4},
    tle::TLE;
    sgp4c::Sgp4Constants{T} = sgp4c_wgs84
) where T

    # Constants.
    d2r           =  π/180      # Degrees to radians.
    revday2radmin = 2π/1440     # Revolutions per day to radians per minute.

    # Obtain the data from the TLE.
    epoch = tle.epoch
    n_0   = tle.n * revday2radmin
    e_0   = tle.e
    i_0   = tle.i * d2r
    Ω_0   = tle.Ω * d2r
    ω_0   = tle.ω * d2r
    M_0   = tle.M * d2r
    bstar = tle.bstar

    # Create the new SGP4 structure.
    sgp4d = sgp4_init(
        tle.epoch,
        n_0,
        e_0,
        i_0,
        Ω_0,
        ω_0,
        M_0,
        tle.bstar;
        sgp4c = sgp4c
    )

    # Create and return the orbit propagator structure.
    return OrbitPropagatorSGP4(sgp4d)
end

function propagate!(orbp::OrbitPropagatorSGP4, t::Number)
    # Auxiliary variables.
    sgp4d = orbp.sgp4d

    # Propagate the orbit.
    r_teme, v_teme = sgp4!(sgp4d, t / 60)

    # Return the information in [m].
    return 1000r_teme, 1000v_teme
end

function step!(orbp::OrbitPropagatorSGP4, Δt::Number)
    # Auxiliary variables.
    sgp4d = orbp.sgp4d

    # Propagate the orbit.
    r_teme, v_teme = sgp4!(sgp4d, sgp4d.Δt + Δt / 60)

    # Return the information in [m].
    return 1000r_teme, 1000v_teme
end
