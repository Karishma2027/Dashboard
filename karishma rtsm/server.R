## Shiny Server component for dashboard

my_data <- read.csv("FTSC_2020-2022.csv")

function(input, output, session){
  
  # Data table Output
  output$dataT <- renderDataTable(my_data)
  
  # Rendering the box header  
  output$head1 <- renderText(
    paste("5 States/UTs with high rate of functional FTSCs as of 2022")
  )
  
  # Rendering the box header 
  output$head2 <- renderText(
    paste("5 States/UTs with low rate of functional FTSCs as of 2022")
  )
  
  # Rendering table with 5 states with high functional FTSCs
  output$top5 <- renderTable({
    my_data %>% 
      select(state, FTSC2022) %>% 
      arrange(desc(FTSC2022)) %>% 
      head(5)
  })
  
  # Rendering table with 5 states with low functional FTSCs
  output$low5 <- renderTable({
    my_data %>% 
      select(state, FTSC2022) %>% 
      arrange(FTSC2022) %>% 
      head(5)
  })
  
  # For Structure output
  output$structure <- renderPrint({
    str(my_data)
  })
  
  # For Summary Output
  output$summary <- renderPrint({
    summary(my_data)
  })
  
  # For histogram - distribution charts
  output$histplot <- renderPlotly({
    p1 <- plot_ly(my_data, x = ~FTSC2022, type = "histogram") %>% 
      layout(xaxis = list(title = "No. of functional FTSCs (2022)"))
    
    p2 <- plot_ly(my_data, x = ~FTSC2022, type = "box") %>% 
      layout(yaxis = list(showticklabels = FALSE))
    
    subplot(p2, p1, nrows = 2, shareX = TRUE) %>%
      hide_legend() %>% 
      layout(title = "Distribution chart - Histogram and Boxplot",
             yaxis = list(title = "Frequency"))
  })
  
  ### Bar Charts - State/UT wise trend
  output$bar <- renderPlotly({
    plot_ly(my_data, x = ~state, y = ~FTSC2022, type = "bar") %>% 
      layout(title = "State/UT wise functional FTSCs as of 2022",
             xaxis = list(title = "State/UT"),
             yaxis = list(title = "No. of functional FTSCs (2022)"))
  })
  
  ### Scatter Charts 
  output$scatter <- renderPlotly({
    plot_ly(my_data, x = ~FTSC2021, y = ~FTSC2022, type = "scatter", mode = "markers") %>%
      add_lines(y = ~FTSC2022, mode = "lines", line = list(dash = "dot")) %>%
      layout(title = "Relation between functional FTSCs in 2021 and 2022",
             xaxis = list(title = "No. of functional FTSCs (2021)"),
             yaxis = list(title = "No. of functional FTSCs (2022)"))
  })
  
  ## Correlation plot
  output$cor <- renderPlotly({
    my_df <- my_data %>% 
      select(-state)
    
    # Compute a correlation matrix
    corr <- cor(my_df)
    
    # Compute a matrix of correlation p-values
    p.mat <- cor_pmat(my_df)
    
    corr.plot <- ggcorrplot(
      corr, 
      hc.order = TRUE, 
      lab= TRUE,
      outline.col = "white",
      p.mat = p.mat
    )
    
    ggplotly(corr.plot)
    
  })
  
  # Choropleth map
  output$map_plot <- renderPlot({
    # Your code for choropleth map goes here
    # Ensure to use appropriate column names for state names and functional FTSCs
    # Replace "input$crimetype" with appropriate variable/column name
  })
}
