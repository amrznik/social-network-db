package sql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.Scanner;

/**
 * A simple client to connect to the database 'socialnetwork'
 * for sending the queries and receiving the results
 */

public class SQLJDBC {
	public static void main(String args[]) {
		Connection c = null;
		Statement statement = null;
		Scanner input = new Scanner(System.in);
		String query;
		// String name;
		// String password;
		// String firstname;
		// String middlename;
		// String lastname;
		// String emaill;
		try {

			Class.forName("com.mysql.jdbc.Driver");
			c = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/socialnetwork", "root", "");
			c.setAutoCommit(false);
			// System.out.println("Opened database successfully");

			statement = c.createStatement();

			System.out.println("enter query: ");
			query = input.nextLine();

			// System.out.print("enter name: ");
			// name = input.nextLine();
			// System.out.print("enter password: ");
			// password = input.nextLine();
			// System.out.print("enter firstname ");
			// firstname = input.nextLine();
			// System.out.print("enter middlename ");
			// middlename = input.nextLine();
			// System.out.print("enter lastname: ");
			// lastname = input.nextLine();
			// System.out.print("enter email: ");
			// emaill = input.nextLine();

			String sql = query;
			// String sql = "select * from user";
			// String sql =
			// "INSERT INTO user
			// (token,username,password,name_first,name_middle,name_last,email_id,picture,online,created_at)
			// "
			// + "VALUES (1, '"
			// + name
			// + "', '"
			// + password
			// + "', '"
			// + firstname
			// + "', '"
			// + middlename
			// + "', '"
			// + lastname
			// + "', '" + emaill + "', " + "'1', 1, current_time);";
			// stmt.executeUpdate(sql);
			ResultSet rs = statement.executeQuery(sql);
			ResultSetMetaData rsmd = rs.getMetaData();

			int columnsNumber = rsmd.getColumnCount();
			while (rs.next()) {
				for (int i = 1; i <= columnsNumber; i++) {
					if (i > 1)
						System.out.print(",  ");
					String columnValue = rs.getString(i);
					System.out.print(rsmd.getColumnName(i) + ": " + columnValue);
				}
				System.out.println();
			}

			statement.close();
			c.commit();
			c.close();
			input.close();
		} catch (Exception e) {
			System.err.println(e.getClass().getName() + ": " + e.getMessage());
			System.exit(0);
		}
		// System.out.println("Records created successfully");
	}
}
