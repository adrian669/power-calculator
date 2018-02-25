


server <- function(input, output, session) {
  observe({
    if (input$test == "t test") {
      updateSelectInput(session,
                        "type",
                        "Type of test",
                        choices = c("one.sample", "two.sample", "paired"))
    }
    if (input$test == "Two sample test for proportions") {
      updateSelectInput(session,
                        "type",
                        "Type of test",
                        choices = "two.sample")
    }
  })
  
  
  data = reactive({
    if (input$test == "t test") {
      temp =  crossing(
        n = round(10 ^ seq(1, log10(
          as.numeric(input$n_obs)
        ), 0.01)),
        delta = input$delta,
        sig.level = input$sig.level,
        sd = input$sd
      ) %>%
        invoke(power.t.test,
               .,
               type = input$type,
               alternative = input$alternative) %>%
        tidy() %>%
        mutate(power = round(power, 3))
      
    }
    
    if (input$test == "Two sample test for proportions") {
      temp =  crossing(
        n = round(10 ^ seq(1, log10(
          as.numeric(input$n_obs)
        ), 0.01)),
        sig.level = input$sig.level,
        p1 = input$p1,
        p2 = input$p2
      ) %>%
        invoke(power.prop.test, ., alternative = input$alternative) %>%
        tidy() %>%
        mutate(power = round(power, 3))
    }
    
    return(temp)
  })
  
  
  output$plot <- renderPlotly({
    if (input$test == "t test") {
      p <- ggplot(
        data = data(),
        mapping = aes(
          x = n,
          y = power,
          color = percent(delta),
          text = paste0("Number of observation per group : ",
                        n,
                        "\n",
                        "Power :",
                        power),
          group = 1
        )
      ) +
        geom_line() +
        scale_x_log10(labels = comma_format()) +
        scale_y_continuous(labels = percent_format(), limits = c(0, 1)) +
        labs(
          x = "Number of observations per group (log scale)",
          y = "power",
          color = "Effect size",
          title = paste0(
            "Test : ",
            input$test,
            " ",
            "Type of test : ",
            input$type,
            "\n",
            " ",
            "alternative : ",
            input$alternative
          ),
          subtitle = paste0("Standard deviation : ", input$sd)
        )
      
      gg <- ggplotly(p, tooltip = "text")
      
    }
    
    if (input$test == "Two sample test for proportions") {
      p <- ggplot(
        data = data(),
        mapping = aes(
          x = n,
          y = power,
          color = interaction(p1, p2),
          text = paste0(
            "Number of observations per group :",
            n,
            "\n",
            "Power :",
            power,
            "\n",
            "Probability group 1 :",
            p1,
            "\n",
            "Probability group 2 :",
            p2
          ),
          group = 1
        )
      ) +
        geom_line() +
        scale_x_log10(labels = comma_format()) +
        scale_y_continuous(labels = percent_format(), limits = c(0, 1)) +
        labs(x = "Number of observations per group (log scale)",
             y = "power",
             color = "Probability in each group",
             title = paste0(
               "Test : ",
               input$test,
               " ",
               "Type of test : ",
               input$type,
               "\n",
               " ",
               "alternative : ",
               input$alternative
             ))
      
      gg = plotly::ggplotly(p, tooltip = "text")
      
    }
    
    print(gg)
    
  })
  
  output$table <- DT::renderDataTable({
    data()
  })
  
  
}