library(shiny)
library(tidyverse)
library(broom)
library(scales)
library(plotly)
library(DT)
theme_set(theme_minimal())
pdf(NULL)


ui <- fluidPage(titlePanel("Power test calculator"),
                
                sidebarLayout(
                  sidebarPanel(
                    selectInput(
                      inputId = "test",
                      label = "Choose a test",
                      choices = c("t test",
                                  "Two sample test for proportions")
                    ),
                    
                    selectInput(
                      inputId = "type",
                      label = "Type of test",
                      choices = c("one.sample", "two.sample", "paired")
                    ),
                    
                    selectInput(
                      inputId = "alternative",
                      label = "Alternative hypothesis",
                      choices = c("two.sided", "one.sided")
                    ),
                    
                    selectInput(
                      "n_obs",
                      "Number of observations per group",
                      choices = 10 ^ seq(1, 7, 1),
                      selected = 10 ^ 4
                    ),
                    
                    conditionalPanel(
                      condition = "input.test == 't test'",
                      sliderInput(
                        "delta",
                        "Effect size",
                        min = 0.001,
                        max = 1,
                        value = 0.1
                      )
                    ),
                    
                    conditionalPanel(
                      condition = "input.test == 't test'",
                      numericInput(
                        "sd",
                        "Standard deviation",
                        min = 0.0001,
                        max = Inf,
                        value = 0.1
                      )
                    ),
                    
                    numericInput(
                      "sig.level",
                      "Sig level",
                      min = 0.0001,
                      max = 1,
                      value = 0.05
                    ),
                    
                    conditionalPanel(
                      condition = "input.test == 'Two sample test for proportions'",
                      numericInput(
                        "p1",
                        "Probability in one group",
                        min = 0,
                        max = 1,
                        value = 0.5
                      )
                    ),
                    
                    conditionalPanel(
                      condition = "input.test == 'Two sample test for proportions'",
                      numericInput(
                        "p2",
                        "Probability in other group",
                        min = 0,
                        max = 1,
                        value = 0.5
                      )
                    ),
                    width = 2
                    
                    
                    
                  ),
                  
                  mainPanel(tabsetPanel(
                    tabPanel("Plot", plotlyOutput("plot")),
                    tabPanel("Table", DT::dataTableOutput(outputId = "table"))
                  ), width = 10)
                ))