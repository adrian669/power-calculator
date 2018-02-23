
server <- function(input, output) {
  data = reactive({
    crossing(
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
    
    
    
  })
  
  
  output$plot <- renderPlotly({

    p = ggplot(
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
      labs(x = "Number of observations per group (log scale)",
           y = "power")
    
    gg = plotly::ggplotly(p, tooltip = "text")
    
    print(gg)
    
    
    
  })
  
  output$table <- DT::renderDataTable({
    data()
    
  })
  
  
}