package edu.umass.javajitters;

import java.util.Random;

public class Main {
    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Invalid usage! Please execute as follow: \n java -jar javajitters.jar password");
            System.exit(1);
        }

        String password = args[0];

        if (password.equals("J@v@J1tt3rs&6969")) {
            System.out.println("Congratulations, you've unlocked the secret to a perfect cup of Java!");
        }
        else if (password.equals("J@v@J1tt3rs&55")) {
            System.out.println("You must have had a triple-shot espresso to crack this password!");
        }
        else if (password.equals("J@v@J1tt3rs&56")) {
            System.out.println("Java Jitters has met its match with your password cracking skills!");
        }
        else if (password.equals("J@v@J1tt3rs&57")) {
            System.out.println("Your Java knowledge is brewing to perfection with this password!");
        }
        else if (password.equals("J@v@J1tt3rs&54")) {
            System.out.println("UMASS{C0ff33_m@k3s_m3_J@v@_crazy}");
        }
        else if (password.equals("J@v@J1tt3rs&58")) {
            System.out.println("You've made Java Jitters look like decaf with your password cracking prowess!");
        }
            else if (password.equals("J@v@J1tt3rs&59")) {
            System.out.println("Looks like you've got the Java Jitters under control with this password!");
        }
        else if (password.equals("J@v@J1tt3rs&60")) {
            System.out.println("Java Jitters ain't got nothin' on you and your cracking skills!");
        }
        else if (password.equals("J@v@J1tt3rs&61")) {
            System.out.println("The Java world bows down to you and your password cracking skills!");
        }
        else if (password.equals("J@v@J1tt3rs&62")) {
            System.out.println("You've unlocked the Java treasure with this password!");
        }
        else if (password.equals("J@v@J1tt3rs&63")) {
            System.out.println("The Java community thanks you for this epic password!");
        }
        else {
            Random rand = new Random();
            int num = rand.nextInt(5) + 1; // Generates a random number between 1 and 5

            switch (num) {
                case 1:
                    System.out.println("Incorrect password! Did you try 'coffee'?");
                    break;
                case 2:
                    System.out.println("Sorry, that's not the right password. Maybe try 'javaislife'?");
                    break;
                case 3:
                    System.out.println("Nope, that's not it either. Have you tried 'beansbeansbeans'?");
                    break;
                case 4:
                    System.out.println("Hmmm, that password isn't working. How about 'javajava123'?");
                    break;
                case 5:
                    System.out.println("Sorry, that's still not the right password. Maybe try 'espressoyourself'?");
                    break;
            }
        }
    }
}