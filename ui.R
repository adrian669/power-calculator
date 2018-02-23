library(shiny)
library(tidyverse)
library(broom)
library(scales)
library(plotly)
library(DT)
theme_set(theme_minimal())
pdf(NULL)

ui <- fluidPage(titlePanel("Power t test calculator"),
                
                sidebarLayout(
                  sidebarPanel(
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
                    
                    sliderInput(
                      "delta",
                      "Effect size",
                      min = 0.001,
                      max = 1,
                      value = 0.1
                    ),
                    
                    sliderInput(
                      "sd",
                      "Standard deviation",
                      min = 0.001,
                      max = 10,
                      value = 0.1
                    ),
                    
                    sliderInput(
                      "sig.level",
                      "Sig level",
                      min = 0.001,
                      max = 1,
                      value = 0.01
                    )
                  ),
                  
                  mainPanel(plotlyOutput("plot"),
                            DT::dataTableOutput(outputId = "table")
                            )
                  
                  
                ))