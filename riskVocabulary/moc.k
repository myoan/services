Import("Type.Json");
Import("MiniKonoha.Map");
Import("JavaStyle.Object");
Import("Syntax.Null");
Import("Syntax.GlobalVariable");
Import("Syntax.CStyleWhile");
Import("JavaScript.String");
Import("JavaScript.Array");
Import("JavaScript.Regexp");
Import("dscript.subproc");
Import("Lib.Mecab");
Import("MiniKonoha.Sql");
Import("MiniKonoha.Syntax"); // for debug
Import("Deos.DCaseCloud");

API repo = new API("dcasedb", "dcasedb");

Strategy makeStrategy(API repo, int argumentId, String description) {
	Json json = new Json();
	json.setString("description",description);
	json.setString("type","Strategy");
	return repo.CreateDBNode(argumentId, json) as Strategy;
}

Goal makeGoal(API repo, int argumentId, String description) {
	Json json = new Json();
	json.setString("description",description);
	json.setString("type","Goal");
	return repo.CreateDBNode(argumentId, json) as Goal;
}

Evidence makeEvidence(API repo, int argumentId, String description) {
	Json json = new Json();
	json.setString("description",description);
	json.setString("type","Evidence");
	return repo.CreateDBNode(argumentId, json) as Evidence;
}

Context makeContext(API repo, int argumentId, String description) {
	Json json = new Json();
	json.setString("description",description);
	json.setString("type","Context");
	return repo.CreateDBNode(argumentId, json) as Context;
}

Connection create() {
	String USER_NAME = "root"; // Enter Your MySQL UserName
	String PASSWD = "ybkkbhc"     // Enter Your MySQL Password
	Connection con = new Connection("mysql://" + USER_NAME + ":" + PASSWD + "@localhost:3306");
	return con;
}

String[] getNoun(String input) {
	Tagger m = new Tagger();
	String result = m.parse(input);
	String[] strs = result.split(/\n/);
	boolean isPreWordNoun = false;
	String preNoun = "";
	int i = 0;
	String[] ret = new String[];
	while(i < strs.getSize()) {
		String line = strs[i];
		if (line.search(/名詞/) > -1) {
			String[] noun = line.split(/[ \t]+/);
			ret.add(noun[0]);
			if (isPreWordNoun) {
				ret.add(preNoun + noun[0]);
			}
			preNoun = noun[0];
			isPreWordNoun = true;
		}
		else {
			isPreWordNoun = false;
			preNoun = "";
		}
		i =  i + 1;
	}
	return ret;
}

String[] getRisks(Connection con, String title, String[] strs) {
	String[] ret = new String[];
	int i = 0;
	DCaseArgument args = global.repo.CreateArgument(title);
	int args_id = args.argument_id;
	DBNode root = global.repo.GetArgument(args_id).GetRoot();
	DBNode strategy = global.repo.CreateDBNode(Json.parse("{\"type\": \"Strategy\", \"description\": \"リスクに分割して議論\"}"));
	global.repo.InsertLink(args_id, root, strategy);
	System.p("Argument id: " + args_id);
	boolean start_flag = true;
	while (i < strs.getSize()) {
		String noun = strs[i];
		ResultSet risks = con.query("select words FROM risk_expression, risk_keyword, risk_kw_relation where risk_expression.id = risk_kw_relation.risk_id AND risk_keyword.id = risk_kw_relation.kw_id AND risk_keyword.keyword = '" + noun + "'");
		if (risks.getSize() == 0) {
			i = i + 1;
			start_flag = true;
			continue;
		}
		DBNode kw_goal;
		while (risks.next()) {
			if (start_flag) {
				kw_goal = global.repo.CreateDBNode(Json.parse("{\"type\": \"Goal\", \"description\": \"" + noun + "\"}"));
				global.repo.InsertLink(args_id, strategy, kw_goal);
				start_flag = false;
			}
			DBNode risk_goal = global.repo.CreateDBNode(Json.parse("{\"type\": \"Goal\", \"description\": \"" + risks.getString("words") + "\"}"));
			global.repo.InsertLink(args_id, kw_goal, risk_goal);
			ret.add(risks.getString("words"));
		}
		i = i + 1;
		start_flag = true;
	}
	return ret;
}

void main() {
	Connection con = create();
	con.query("USE alertme_moc");

	String input = "RAMディスクにデータをコピーする";
	System.p("Input: " + input + "\n");
	String[] result = getNoun(input);
	System.p(getRisks(con, input, result));
}

main();
