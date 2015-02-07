import pisd

session = pisd.PISD_Session('enrico.borba.1','inferno&7', True)
session.login()
session.goto_gradesummary()