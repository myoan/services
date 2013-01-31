Import("Syntax.CStyleWhile")
Import("Syntax.Null")
Import("Type.File")
Import("MiniKonoha.Sql")
Import("JavaScript.String");
Import("JavaScript.Regexp");
Import("JavaScript.Array");

Connection db_open() {
	String USER_NAME = "root";
	String PASSWD = "ybkkbhc";
	Connection con = new Connection("mysql://" + USER_NAME + ":" + PASSWD + "@localhost:3306");
	return con;
}

void importDB(Connection con, String[] map) {
	ResultSet r = con.query("INSERT INTO risk_expression (fault, failure, words) VALUE ('" + map[1] + "','" + map[2] + "','" + map[3] + "')");
	ResultSet r = con.query("INSERT INTO risk_keyword (keyword) VALUE ('" + map[0] + "')");
	int id = con.getInsertId();
	ResultSet r = con.query("INSERT INTO risk_kw_relation (id, kw_id, risk_id) VALUE (" + id + "," + id + "," + id + ")");
	System.p(id);
}

void main() {
	Connection con = db_open()
	con.query("USE alertme_moc");
	String file = FILE.scriptPath("risk_key_map.csv");
	FILE fp = new FILE(file, "r");
	fp.setReaderCharset("UTF-8");
	String line;
	while ((line = fp.readLine()) != null) {
		String[] map = line.split(",");
		System.p(map);
		importDB(con, map);
	}
	con.close()
}

main();
