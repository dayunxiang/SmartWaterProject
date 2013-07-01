SmartWaterProject
=================

Web services for Smart Leak Detection

To compile:
-ant

to create jdbc resource:
-asadmin add-resources "glassfish-resources.xml"

to create jdbcRealms:
-asadmin create-auth-realm --classname com.sun.enterprise.security.auth.realm.jdbc.JDBCRealm --property jaas-context=jdbcRealm:datasource-jndi="jdbc/auth":user-table=users:user-name-column=email:password-column=password:group-table=users_groups:group-name-column=groupname:digest-algorithm=SHA-512 userMgmtJdbcRealm

