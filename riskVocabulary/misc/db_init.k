Import("Syntax.CStyleWhile")
Import("Syntax.Null")
Import("Type.File")
Import("MiniKonoha.Sql")
Import("JavaScript.String");
Import("JavaScript.Regexp");
Import("JavaScript.Array");

void main() {
	String USER_NAME = "root";
	String PASSWD = "ybkkbhc";
	Connection con = new Connection("mysql://" + USER_NAME + ":" + PASSWD + "@localhost:3306");
	con.query("DROP DATABASE alertme_moc");
	con.query("CREATE DATABASE alertme_moc");
}

main();
