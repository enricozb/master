#include <curl/curl.h>
#include "Browser/Browser.hpp"
#include <iostream>
#include <stdio.h>
#include <map>

using namespace std;

void initbr(Browser* br) {
	br->set_handle_gzip(true);
	br->set_handle_redirect(true);
	br->set_handle_ssl(true);
	map<string, string> headers;
	headers["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8";
	headers["Accept-Encoding"] = "gzip,deflate,sdch";
	headers["Accept-Language"] = "en-US,en;q=0.8,es;q=0.6";
	headers["Cache-Control"] = "max-age=0";
	headers["Connection"] = "keep-alive";
	headers["Content-Type"] = "application/x-www-form-urlencoded";
	headers["Host"] = "sso.portal.mypisd.net";
	headers["Origin"] = "https://sso.portal.mypisd.net";
	headers["Referer"] = "https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin";
	br->addheaders(headers);	


	br->open("https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin");
}

int main() {
	Browser br;
	initbr(&br);
	
	br.select_form(0);
	*br.form["username"] = "enrico.borba.1";
	*br.form["password"] = "inferno&7";
	*br.form["lt"] = "_c239FACDF-97A6-7093-07A3-0685CBCCBC45_kA88BCBB1-3433-EBB7-1532-67AA9E702208";
	*br.form["_eventId"] = "submit";
	br.submit();
	cout<<br.response();
}