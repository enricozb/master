import java.io.*;
import java.util.*;

public class SMS {
	public static int fl = 4;
	public static int fr = 6;

	public static void main(String[] args) {
		System.out.println(get_seq("cake"));
	}

	public static float get_dist(int k1, int k2) {
		
	}

	public static String get_key(char c) {
		char out = 0;
		int num = 0;
		if('a' <= c && c <= 'c') {
			num = c - 'a';
			out = '2';
		}
		if('d' <= c && c <= 'f') {
			num = c - 'd';
			out = '3';
		}
		if('g' <= c && c <= 'i') {
			num = c - 'g';
			out = '4';
		}
		if('j' <= c && c <= 'l') {
			num = c - 'j';
			out = '5';
		}
		if('m' <= c && c <= 'o') {
			num = c - 'm';
			out = '6';
		}
		if('p' <= c && c <= 's') {
			num = c - 'p';
			out = '7';
		}
		if('t' <= c && c <= 'v') {
			num = c - 't';
			out = '8';
		}
		if('w' <= c && c <= 'z') {
			num = c - 'w';
			out = '9';
		}
		String s = "";
		for(int i = 0; i <= num; i++) {
			s+= out;
		}
		return s;
	}

	public static String get_seq(String str) {
		String out = "";
		str = str.toLowerCase();
		for(int i = 0; i < str.length(); i++) {
			char c = str.charAt(i);
			String key = get_key(c);
			if(out.length() > 0 && key.charAt(0) == out.charAt(out.length() - 1)) {
				out += '#';
			}
			out += key;
		}

		return out;
	}
}