# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#    API implementation for J4 orbit propagator.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

get_epoch(orbp::OrbitPropagatorJ4) = orbp.j4d.epoch

function get_mean_elements(orbp::OrbitPropagatorJ4)
    j4d = orbp.j4d
    orb = KeplerianElements(
        j4d.epoch + j4d.Δt / 86400,
        j4d.al_k * j4d.j4c.R0,
        j4d.e_k,
        j4d.i_k,
        j4d.Ω_k,
        j4d.ω_k,
        j4d.f_k
    )

    return orb
end

"""
    init_orbit_propagator(Val(:J4), epoch::Number, a_0::Number, e_0::Number, i_0::Number, Ω_0::Number, ω_0::Number, f_0::Number, dn_o2::Number = 0, ddn_o6::Number = 0; kwargs...)
    init_orbit_propagator(Val(:J4), orb_0::Orbit, dn_o2::Number = 0, ddn_o6::Number = 0; kwargs...)

Initialize the J4 orbit propagator.

# Args

- `epoch::Number`: Initial orbit epoch [Julian Day].
- `a_0::Number`: Initial mean semi-major axis [m].
- `e_0::Number`: Initial mean eccentricity.
- `i_0::Number`: Initial mean inclination [rad].
- `Ω_0::Number`: Initial mean right ascension of the ascending node [rad].
- `ω_0::Number`: Initial mean argument of perigee [rad].
- `f_0::Number`: Initial mean true anomaly [rad].
- `dn_o2::Number`: (OPTIONAL) First time derivative of mean motion divided by 2
    [rad/s²]. (**Default** = 0).
- `ddn_o6::Number`: (OPTIONAL) Second time derivative of mean motion divided by
    6 [rad/s³]. (**Default** = 0).
- `orb_0::Orbit`: Object of type [`Orbit`](@ref) with the initial mean orbital
    elements [SI].

# Keywords

- `j4c::J4PropagatorConstants`: J4 orbit propagator constants.
    (**Default** = `j4c_egm08`).
"""
function init_orbit_propagator(::Val{:J4},
    epoch::Number,
    a_0::Number,
    e_0::Number,
    i_0::Number,
    Ω_0::Number,
    ω_0::Number,
    f_0::Number,
    dn_o2::Number = 0,
    ddn_o6::Number = 0;
    j4c::J4PropagatorConstants{T} = j4c_egm08
) where T
    # Create the new J4 propagator structure.
    j4d = j4_init(
        epoch,
        a_0,
        e_0,
        i_0,
        Ω_0,
        ω_0,
        f_0,
        dn_o2,
        ddn_o6;
        j4c = j4c
    )

    # Create and return the orbit propagator structure.
    return OrbitPropagatorJ4(j4d)
end

function init_orbit_propagator(
    ::Val{:J4},
    orb_0::Orbit,
    dn_o2::Number = 0,
    ddn_o6::Number = 0;
    j4c::J4PropagatorConstants = j4c_egm08
)
    # Convert the orbit representation to Keplerian elements.
    k_0 = convert(KeplerianElements, orb_0)

    return init_orbit_propagator(
        Val(:J4),
        k_0.t,
        k_0.a,
        k_0.e,
        k_0.i,
        k_0.Ω,
        k_0.ω,
        k_0.f,
        dn_o2,
        ddn_o6;
        j4c = j4c
    )
end

function propagate!(orbp::OrbitPropagatorJ4, t::Number)
    # Auxiliary variables.
    j4d = orbp.j4d

    # Propagate the orbit.
    r_i, v_i = j4!(j4d, t)

    # Return.
    return r_i, v_i
end

function step!(orbp::OrbitPropagatorJ4, Δt::Number)
    # Auxiliary variables.
    j4d = orbp.j4d

    # Propagate the orbit.
    r_i, v_i = j4!(j4d, j4d.Δt + Δt)

    # Return the information about the step.
    return r_i, v_i
end
