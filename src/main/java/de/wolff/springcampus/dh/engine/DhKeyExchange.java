package de.wolff.springcampus.dh.engine;

import java.io.Serializable;
import java.math.BigInteger;
import java.util.Random;


/**
 * Implements the Diffie-Hellman Key Exchange. The methods represent the single steps that are
 * required for the exchange. This class can be used by the Alice as well as Bob role. Both
 * instantiate an object of this class, execute the steps necessary by the respective role and
 * feeding in the values from the exchange partner.
 *
 * The DH exchange parameters p and g are chosen randomly and also in a safe way, which means that
 * the prime numbers are chosen so that they fulfill certain properties so that they create a secure
 * sub-group. For more information about how to choose secure values you may want to read chapter 11
 * of the book "Cryptography Engineering" (2010) by Bruce Schneier et al.
 *
 * For saving computation time and in order to have numbers for the parameters that are not too
 * long, the range of p and g is not very large! This program is intended to do a real-life DH key
 * exchange during a presentation with a volunteer from the audience. We need to exchange the
 * numbers verbally, so they should not be too long. Therefore, we use a short bit length for p and
 * g here. This exchange here is solely for demo purposes and should never be used for real key
 * exchanges!
 *
 * @author Benjamin Wolff
 */
public class DhKeyExchange implements Serializable {

    private static final BigInteger ONE = BigInteger.ONE;
    private static final BigInteger TWO = BigInteger.valueOf(2);
    private static final BigInteger UPPER_BOUND_FOR_PADLOCK_CODE = BigInteger.valueOf(10000);
    private static final int P_BIT_LENGTH = 16; // Must be smaller than 32 bits!
    private static final int MAX_TRIES_FINDING_PRIME = 10000;

    /**
     * The Pseudo Random Number Generator (PRNG).
     *
     * The Java Random class is NOT SAFE ENOUGH to be used in real cryptographic systems! But for
     * this demo it will do.
     */
    private final Random prng = new Random();

    private BigInteger p;
    private BigInteger g;
    private BigInteger x;
    private BigInteger gx;
    private BigInteger gxOther;
    private BigInteger k;

    /**
     * This code is derived from the exchanged secret key k and is used for a real physical 4-digit
     * padlock in the DH key exchange demo.
     */
    private BigInteger padlockCode;

    /**
     * This method is used when p and q are provided by the other peer, usually by Alice. Bob only
     * sets the values in this case.
     */
    public void setValuesForPandG(BigInteger p, BigInteger g) {
        ensureNotNull("Values for p and q must not be null", p, g);
        this.p = p;
        this.g = g;
    }

    /**
     * Generates suitable and random values for p and g. This method is usually used by Alice, who
     * initiates the key exchange with Bob. She would then communicate these two values publicly to
     * Bob.
     */
    public void generateValuesForPandG() {
        generateValueForP();
        generateValueForG();
    }

    /**
     * Finds a safe prime p such that:
     *
     * p = 2*q + 1, where p and q are prime.
     */
    private void generateValueForP() {
        int tries = 0;
        BigInteger pCandidate;

        do {
            pCandidate = generateCandidateForP();
            tries++;

            if (!isValidValueForP(pCandidate)) {
                pCandidate = null;
            }
        } while ((tries < MAX_TRIES_FINDING_PRIME) && (pCandidate == null));

        if (pCandidate == null) {
            throw new RuntimeException("Could not find a suitable prime for p");
        }

        p = pCandidate;
    }

    private BigInteger generateCandidateForP() {
        return BigInteger.probablePrime(P_BIT_LENGTH, prng).multiply(TWO).add(ONE);
    }

    private boolean isValidValueForP(BigInteger pCandidate) {
        if (TWO.compareTo(pCandidate) >= 0) {
            return false;
        }

        if (!pCandidate.isProbablePrime(16)) {
            return false;
        }

        return true;
    }

    /**
     * Finds a value for g such that:
     *
     * g = a^2, where a is in range [2, ..., p - 2] and g != 1 and g != p - 1
     */
    private void generateValueForG() {
        ensureNotNull("Missing value p for generating g", p);

        int tries = 0;
        BigInteger gCandidate;

        do {
            gCandidate = generateCandidateForG();
            tries++;

            if (!isValidValueForG(gCandidate)) {
                gCandidate = null;
            }
        } while ((tries < MAX_TRIES_FINDING_PRIME) && (gCandidate == null));

        if (gCandidate == null) {
            throw new RuntimeException("Could not find a suitable number for g");
        }

        g = gCandidate;
    }

    private BigInteger generateCandidateForG() {
        // WARNING: The following code only works as long as p fits in an integer (32 bits)!
        return BigInteger.valueOf(2 + prng.nextInt(p.intValue() - 1)).modPow(TWO, p);
    }

    private boolean isValidValueForG(BigInteger gCandidate) {
        return !ONE.equals(gCandidate) && !p.subtract(ONE).equals(gCandidate);
    }

    /**
     * Chooses a random value for x in range [1, ..., p - 1]
     *
     * This x must be kept absolutely secret in the exchange process.
     */
    public void generateValueForX() {
        ensureNotNull("Missing value p for generating x", p);

        x = BigInteger.valueOf(1 + prng.nextInt(p.intValue() - 1));
    }

    /**
     * Calculates g^x mod p
     */
    public void calculateGx() {
        ensureNotNull("Missing values for calculating gx", x, p, g);

        gx = g.modPow(x, p);
    }

    /**
     * Calculates the secret key k such that: k = (g^xb)^xa mod p
     */
    public void calculateK() {
        ensureNotNull("Missing values for calculating k", gxOther, x, p);

        k = gxOther.modPow(x, p);
        padlockCode = k.mod(UPPER_BOUND_FOR_PADLOCK_CODE);
    }

    private void ensureNotNull(String errorMessage, Object... objects) {
        for (Object object : objects) {
            if (object == null) {
                throw new IllegalArgumentException(errorMessage);
            }
        }
    }

    public void reset() {
        p = null;
        g = null;
        x = null;
        gx = null;
        gxOther = null;
        k = null;
        padlockCode = null;
    }

    public BigInteger getGxOther() {
        return gxOther;
    }

    public void setGxOther(BigInteger gxOther) {
        this.gxOther = gxOther;
    }

    public BigInteger getP() {
        return p;
    }

    public BigInteger getG() {
        return g;
    }

    public BigInteger getX() {
        return x;
    }

    public BigInteger getGx() {
        return gx;
    }

    public BigInteger getK() {
        return k;
    }

    public BigInteger getPadlockCode() {
        return padlockCode;
    }

    public String getPadlockCodeAsString() {
        return (padlockCode != null) ? String.format("%04d", padlockCode) : null;
    }

    @Override
    public String toString() {
        return new StringBuilder("DH Parameters[").append("p=" + p).append(";g=" + g).append(";x=" + x)
                .append(";gx=" + gx).append(";gxOther=" + gxOther).append(";k=" + k)
                .append(";padlockCode=" + padlockCode).append("]").toString();
    }
}
