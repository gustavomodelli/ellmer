library(shiny)
library(ellmer)

Sys.setenv(
  
  GOOGLE_API_KEY = 'AIzaSyClCeS4SiCDyuCRVL2XPum6KWTEHSWC0a8'
)

# Define the system prompt for the chatbot
especialista <- 'Considere que você é um nefrologista especialista e está avaliando se há necessidade de encaminhamento para o especialista ou não. Considere o protocolo de encaminhamento a seguir considerando as categorias: doença renal crônica, litíase, hipertensão, infecção do trato urinário (ITU), diabetes ou cistos. Responda com breve resumo da indicação, patologia (DRC, ITU, cisto, litíase, diabetes, hipertensão ou outros), indicação (sim/não/incompleto), faça comentários a respeito do caso clínico com possíveis sugestões de tratamento'

protocolo_litiase <- '– Infecção urinária recorrente:
Condições clínicas que indicam a necessidade de encaminhamento para nefrologia:
 ITU recorrente (três ou mais infecções urinárias no período de um ano) mesmo com profilaxia adequada, após
exclusão de causas anatômicas urológicas ou ginecológicas.
Condições clínicas que indicam a necessidade de encaminhamento para urologia:
 alteração anatômica no trato urinário que provoque ITU recorrente.
Condições clínicas que indicam a necessidade de encaminhamento para ginecologia:
 alteração anatômica ginecológica que provoque ITU recorrente.'

protocolo_drc <- 'Doença renal crônica:
Condições clínicas que indicam a necessidade de encaminhamento para nefrologia:
 taxa de Filtração Glomerular (TFG) < 30 ml/min/1,73 m2
(estágios 4 e 5) (ver quadro 1 no anexo) ; ou
 proteinúria (ver quadro 2 no anexo); ou
 hematúria persistente (confirmada em dois exames de EQU/EAS/Urina tipo 1, com 8 semanas de intervalo
entre os mesmos e pesquisa de hemácias dismórficas positiva); ou
 alterações anatômicas que provoquem lesão ou perda de função renal (ver quadro 3 no anexo); ou
 perda rápida da função renal (>5 ml/min/1,73 m2 em 6 meses, com uma TFG <60 ml/min/1,73m2
, confirmado
em dois exames); ou
 presença de cilindros com potencial patológico (céreos, largos, graxos, epiteliais, hemáticos ou leucocitários)'

protocolo_hipertensão <- 'Hipertensão arterial sistêmica: Condições clínicas que indicam a necessidade de encaminhamento para nefrologia ou cardiologia ou
endocrinologia (conforme a principal suspeita clínica da hipertensão secundária):
 suspeita de hipertensão secundária; ou
 falta de controle da pressão com no mínimo três medicações anti-hipertensivas em dose plena, após avaliação
da adesão'

protocolo_itu <- '– Infecção urinária recorrente:
Condições clínicas que indicam a necessidade de encaminhamento para nefrologia:
 ITU recorrente (três ou mais infecções urinárias no período de um ano) mesmo com profilaxia adequada, após
exclusão de causas anatômicas urológicas ou ginecológicas.
Condições clínicas que indicam a necessidade de encaminhamento para urologia:
 alteração anatômica no trato urinário que provoque ITU recorrente.
Condições clínicas que indicam a necessidade de encaminhamento para ginecologia:
 alteração anatômica ginecológica que provoque ITU recorrente'

protocolo_diabetes <- 'Diabetes mellitus:
Condições clínicas que indicam a necessidade de encaminhamento para nefrologia:
 pacientes com taxa de filtração glomerular < 30 ml/min/1,73 m2
(estágios 4 e 5) ; ou
 proteinúria (macroalbuminúria) ; ou
 perda rápida da função renal (>5 mL/min/1,73 m2 em um período de 6 meses, com uma TFG <60
mL/min/1,73 m2 confirmado em dois exames)'

protocolo_cisto <- 'Cistos/doença policística renal:
Condições clínicas que indicam a necessidade de encaminhamento para nefrologia:
 suspeita de doença policística renal (ver quadro 5, no anexo).
Condições clínicas que indicam a necessidade de encaminhamento para urologia:
 cistos com alterações sugestivas de malignidade (achados ecográficos como paredes espessas e
irregulares, septações, calcificações ou resultado de tomografia com classificação de Bosniak maior ou
igual a 2F); ou
 cistos simples sintomáticos (dor lombar, hematúria persistente, obstrução de via urinária)'

# Create chat model
chat_google <- chat_gemini(system_prompt = paste(especialista, protocolo_litiase, protocolo_drc, 
                                                 protocolo_hipertensão, protocolo_itu, protocolo_diabetes, 
                                                 protocolo_cisto, sep = "\n"))

# UI - User Interface
ui <- fluidPage(
  titlePanel("Nefrology AI Assistant"),
  
  sidebarLayout(
    sidebarPanel(
      textAreaInput("paciente_input", "Impute the patient characteristics here:", 
                    placeholder = "Ex: 45-year-old male with hypertension and proteinuria..."),
      actionButton("submit", "Submit")
    ),
    
    mainPanel(
      h3("AI Response"),
      verbatimTextOutput("chat_response")
    )
  )
)

# Server - Backend logic
server <- function(input, output) {
  observeEvent(input$submit, {
    req(input$paciente_input)
    
    response <- chat_google$chat(input$paciente_input)
    
    output$chat_response <- renderText({
      response
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)
