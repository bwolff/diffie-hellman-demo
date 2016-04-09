package de.wolff.springcampus.dh.engine;

import static org.junit.Assert.assertEquals;

import org.junit.Test;


public class DhKeyExchangeTest {

    DhKeyExchange alice = new DhKeyExchange();
    DhKeyExchange bob = new DhKeyExchange();

    @Test
    public void testKeyExchange() {
        // We simply run the key exchange many times to make sure it succeeds
        // most of the time.
        for (int i = 0; i < 2000; i++) {
            doKeyExchange();
        }
    }

    private void doKeyExchange() {
        // Alice calculates the public p and g and sends them to Bob
        alice.generateValuesForPandG();
        bob.setValuesForPandG(alice.getP(), alice.getG());

        // Alice calculates her secret xa and the public g^xa
        alice.generateValueForX();
        alice.calculateGx();

        // Bob calculates his secret xb and the public g^xb
        bob.generateValueForX();
        bob.calculateGx();

        // Alice and Bob exchange their public g^x values
        bob.setGxOther(alice.getGx());
        alice.setGxOther(bob.getGx());

        // Alice and Bob calculate the secret shared key k
        alice.calculateK();
        bob.calculateK();

        // Now Alice and Bob should share the same secret key k
        try {
            assertEquals(alice.getK(), bob.getK());
            assertEquals(alice.getPadlockCode(), bob.getPadlockCode());
        } catch (AssertionError ae) {
            // Print the DH parameters to sysout in case of a test failure for
            // troubleshooting.
            System.out.println("Alice: " + alice.toString());
            System.out.println("Bob: " + bob.toString());
            throw ae;
        }
    }
}
