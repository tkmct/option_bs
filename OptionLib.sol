pragma solidity >=0.4.0 <0.7.0;
pragma experimental ABIEncoderV2;
import {Fraction as F} from "Fraction.sol";

/**
 * @title OptionLib
 * @dev Option Library
 */
contract OptionLib_Fraction {
    uint256 number;

    function negate(F.fractionNumber memory f)
        internal
        pure
        returns (F.fractionNumber memory)
    {
        return F.fractionNumber(-f.numerator, f.denominator);
    }

    /**
     * @dev calculate option premium
     * @return value of 'number'
     *
     * s = Current underlying assets' price
     * k = Strike price
     * r = Risk-free intereset rate
     * t = Time to maturity in year
     * v = volatility
     */
    function calc_premium(
        F.fractionNumber memory s,
        F.fractionNumber memory k,
        F.fractionNumber memory r,
        F.fractionNumber memory t,
        F.fractionNumber memory v
    ) public pure returns (F.fractionNumber memory) {
        F.fractionNumber memory sqrt_t = F.sqrt(t);
        F.fractionNumber memory two = F.fractionNumber(2, 1);

        F.fractionNumber memory d2 =
            F.div(
                F.add(
                    F.ln(F.div(s, k)),
                    F.mul(F.sub(r, F.div(F.mul(v, v), two)), t)
                ),
                F.mul(v, sqrt_t)
            );

        return
            F.sub(
                F.mul(s, calc_delta(s, k, r, t, v)),
                F.mul(F.mul(k, F.exp(F.mul(negate(r), t))), F.normsDist(d2))
            );
    }

    /**
     * @dev calculate delta
     */
    function calc_delta(
        F.fractionNumber memory s,
        F.fractionNumber memory k,
        F.fractionNumber memory r,
        F.fractionNumber memory t,
        F.fractionNumber memory v
    ) public pure returns (F.fractionNumber memory) {
        F.fractionNumber memory sqrt_t = F.sqrt(t);
        F.fractionNumber memory two = F.fractionNumber(2, 1);

        return
            F.normsDist(
                F.div(
                    F.add(
                        F.ln(F.div(s, k)),
                        F.mul(F.add(r, F.div(F.mul(v, v), two)), t)
                    ),
                    F.mul(v, sqrt_t)
                )
            );
    }
}
