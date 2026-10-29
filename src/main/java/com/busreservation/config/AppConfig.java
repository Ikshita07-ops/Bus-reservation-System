package com.busreservation.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.orm.hibernate5.HibernateTransactionManager;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import java.util.Properties;

@Configuration
@EnableTransactionManagement
@PropertySource(value = "classpath:application.properties", ignoreResourceNotFound = true)
@ComponentScan(basePackages = {
        "com.busreservation.dao",
        "com.busreservation.service",
        "com.busreservation.util"
})
public class AppConfig {

    @Autowired
    private Environment env;

    @Bean
    public DataSource dataSource() {
        HikariConfig config = new HikariConfig();

        // Support environment variable overrides
        String dbUrl = System.getenv("DB_URL");
        if (dbUrl == null || dbUrl.isEmpty()) {
            dbUrl = env.getProperty("db.url", "jdbc:mysql://localhost:3306/bus_reservation_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&createDatabaseIfNotExist=true");
        }

        String dbUser = System.getenv("DB_USER");
        if (dbUser == null || dbUser.isEmpty()) {
            dbUser = env.getProperty("db.username", "root");
        }

        String dbPassword = System.getenv("DB_PASSWORD");
        if (dbPassword == null) {
            dbPassword = env.getProperty("db.password", "root");
        }

        config.setDriverClassName(env.getProperty("db.driver", "com.mysql.cj.jdbc.Driver"));
        config.setJdbcUrl(dbUrl);
        config.setUsername(dbUser);
        config.setPassword(dbPassword);

        config.setMaximumPoolSize(Integer.parseInt(env.getProperty("hikari.maximumPoolSize", "10")));
        config.setMinimumIdle(Integer.parseInt(env.getProperty("hikari.minimumIdle", "3")));
        config.setIdleTimeout(Long.parseLong(env.getProperty("hikari.idleTimeout", "300000")));
        config.setConnectionTimeout(Long.parseLong(env.getProperty("hikari.connectionTimeout", "20000")));
        config.setMaxLifetime(Long.parseLong(env.getProperty("hikari.maxLifetime", "1200000")));
        config.setPoolName("BusReservationHikariPool");

        return new HikariDataSource(config);
    }

    @Bean
    public LocalSessionFactoryBean sessionFactory() {
        LocalSessionFactoryBean sessionFactory = new LocalSessionFactoryBean();
        sessionFactory.setDataSource(dataSource());
        sessionFactory.setPackagesToScan("com.busreservation.entity");

        Properties hibernateProperties = new Properties();
        hibernateProperties.put("hibernate.dialect", env.getProperty("hibernate.dialect", "org.hibernate.dialect.MySQL8Dialect"));
        hibernateProperties.put("hibernate.show_sql", env.getProperty("hibernate.show_sql", "false"));
        hibernateProperties.put("hibernate.format_sql", env.getProperty("hibernate.format_sql", "true"));
        hibernateProperties.put("hibernate.hbm2ddl.auto", env.getProperty("hibernate.hbm2ddl.auto", "update"));
        hibernateProperties.put("hibernate.enable_lazy_load_no_trans", "true");

        sessionFactory.setHibernateProperties(hibernateProperties);
        return sessionFactory;
    }

    @Bean
    public HibernateTransactionManager transactionManager() {
        HibernateTransactionManager txManager = new HibernateTransactionManager();
        txManager.setSessionFactory(sessionFactory().getObject());
        return txManager;
    }
}
