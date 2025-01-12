# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Deprecation warnings.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Deprecations introduced in SatelliteToolbox v0.11
# ==============================================================================

@deprecate angvel(a, e, i, pert) angvel(a, e, i; pert = pert)
@deprecate angvel(orb, pert) angvel(orb; pert = pert)
@deprecate angvel_to_a(a, e, i, pert; kwargs...) angvel_to_a(a, e, i; pert = pert, kwargs...)
@deprecate angvel_to_a(orb, pert; kwargs...) angvel_to_a(orb; pert = pert, kwargs...)
@deprecate dargp(a, e, i, pert) dargp(a, e, i; pert = pert)
@deprecate dargp(orb, pert) dargp(orb; pert = pert)

# Deprecations introduced in SatelliteToolbox v0.10
# ==============================================================================

@deprecate compute_RAAN_lt ltan_to_raan
