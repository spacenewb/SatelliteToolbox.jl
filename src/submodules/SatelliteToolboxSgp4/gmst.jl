# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Compute the Greenwich Mean Sideral Time (GMST).
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Remarks
# ==============================================================================
#
#   This files was copied from SatelliteToolbox.jl because the functionality is
#   required by SGP4 model. The functions here **must not** be exported to avoid
#   interferences.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# References
# ==============================================================================
#
#   [1] Vallado, D. A (2013). Fundamentals of Astrodynamics and Applications.
#       Microcosm Press, Hawthorn, CA, USA.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

"""
    j2000_to_gmst(j2000_ut1::Number)

Compute the Greenwich Mean Sideral Time (GMST) \\[rad] given the instant
`j2000_ut1` in J2000.0 reference [UT1].

!!! info
    The algorithm is based in **[1]**.

# References

- **[1]** http://www.navipedia.net/index.php/CEP_to_ITRF, accessed 2015-12-01.
"""
function j2000_to_gmst(J2000_UT1::T) where T
    # Julian centuries elapsed from the epoch J2000.0.
    T_UT1 = J2000_UT1 / 36525

    # Greenwich Mean Sideral Time at T_UT1 [s].
    θ_GMST = @evalpoly(
        T_UT1,
        + T(67310.54841),
        + T(876600.0 * 3600 + 8640184.812866),
        + T(0.093104),
        - T(6.2e-6)
    )

    # Reduce to the interval [0, 86400]s.
    θ_GMST = mod(θ_GMST, 86400)

    # Convert to radian and return.
    return θ_GMST * T(π / 43200)
end

"""
    jd_to_gmst(jd_ut1::Number)

Compute the Greenwich Mean Sideral Time (GMST) \\[rad] for the Julian Day
`jd_ut1` [UT1].

!!! info
    The algorithm is based in **[1]**(p. 188).

# References

- **[1]** Vallado, D. A (2013). Fundamentals of Astrodynamics and Applications.
    Microcosm Press, Hawthorn, CA, USA.
"""
jd_to_gmst(JD_UT1::Number) = j2000_to_gmst(JD_UT1 - JD_J2000)
