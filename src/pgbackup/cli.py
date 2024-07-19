from argparse import Action, ArgumentParser

class DriverAction(Action):
    def __call__(self, parser, namespace, values, option_string=None):
        driver, destination = values
        namespace.driver = driver.lower()
        namespace.destination = destination

def create_parser():
    parser = ArgumentParser(description="""
    Back up postgreSQL databases localy or AWS S3
    """)

    parser.add_argument("url", help="URL of database to backups")  # pozíció alapú argumentum (it az első értéket veszi fel.)
    parser.add_argument("--driver",                                # opcionális argumentum egy megadott érték utáni x db argumentumot vár
                        help="how and where to store backups",
                        nargs=2,                                    # itt 2 db-ot
                        action=DriverAction,                        
                        required=True)
    return parser