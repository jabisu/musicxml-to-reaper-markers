-- ReaScript: Import markers from MusicXML. It needs a "Claca" track
reaper.ClearConsole()

-- Show dialog for choosing MusicXML file
retval, filePath = reaper.GetUserFileNameForRead("", "Select MusicXML file with Claca track", ".xml")
if not retval then return end

-- Función para leer el archivo XML
function readFile(file)
  local f = io.open(file, "r")
  if not f then return nil end
  local content = f:read("*all")
  f:close()
  return content
end

-- Read XML file
local xmlContent = readFile(filePath)
if not xmlContent then
  reaper.ShowMessageBox("Error reading file.", "Error", 0)
  return
end

local trackName = "Claca"
local trackFound = false
local idClacaTrack = ""

-- Looking for track name and process only "Claca" track

-- Look for it in trackList (part-list)
local trackList=xmlContent:match('<part%-list>(.-)</part%-list>')

-- Store identifier for "Claca" track in idClacaTrack
for trackNum, trackContent in trackList:gmatch('<score%-part id="(.-)">(.-)</score%-part>') do
 local itemTrackName=trackContent:match('<part%-name>(.-)</part%-name>')
   if itemTrackName == trackName then
    trackFound = true
    idClacaTrack = trackNum
    break
  end
end

-- If there is no "Claca" track, show error message and end
if not trackFound then
  reaper.ShowMessageBox(trackName .. '" not found in MusicXML file.', "Error", 0)
  return
end

-- Variables
local markers = {}
local lastSection = nil  -- Para comparar la sección anterior

function calculate_measure_length(beats, beat_type, tempo)
  if tempo == 0 then return 0 end  -- Evita división por cero
  local tempo_ajustado = tempo * (beat_type / 4)  -- Ajustar tempo si es en corcheas o semicorcheas
  return (beats * 60) / tempo_ajustado
end

local masterTempo= reaper.Master_GetTempo()
reaper.ShowConsoleMsg("Using Master Tempo: " .. masterTempo .. "\n"  )

-- Focus on Claca track
local clacaTrack=xmlContent:match('<part id="'.. idClacaTrack ..'.->(.-)</part>')

-- Recorremos los compases con informacion de Secciones
local currentPosition = 0
local currentBeats = 4
local currentBeatType = 4
for measureNum, measureContent in clacaTrack:gmatch('<measure number="(.-)">(.-)</measure>') do
  
  --reaper.ShowConsoleMsg("Measure: " .. measureNum .. "; pos(time): \n" .. currentPosition .. "\n")
  
  local newMarker = measureContent:match('<rehearsal>(.-)</rehearsal>')
  if newMarker and newMarker ~= "" then
    reaper.ShowConsoleMsg("Marker Found! Measure: " .. measureNum .. ", name: ".. newMarker .. ", Position: ".. currentPosition .. "\n")
    table.insert(markers, {pos = currentPosition, name = newMarker})
  end
  
  -- Update the position (time) according to the time signature and tempo of the current measure
  beats = measureContent:match('<attributes>.-<time>.-<beats>(.-)</beats>')
  if (beats) then
    currentBeats = beats
    --reaper.ShowConsoleMsg("new beat: ".. currentBeats .. "\n")
  end
  
  beatType = measureContent:match('<attributes>.-<time>.-<beat%-type>(.-)</beat%-type>')
  if (beatType) then
    currentBeatType = beatType
    --reaper.ShowConsoleMsg("new beatType: ".. currentBeatType .. "\n")
  end
  
  currentPosition = currentPosition + calculate_measure_length(currentBeats, currentBeatType, masterTempo)
  
end


-- Insert markers into Reaper Project
for _, marker in ipairs(markers) do
  reaper.AddProjectMarker(0, false, marker.pos, 0, marker.name, -1)
end

reaper.ShowMessageBox( #markers .. " markers imported from MusicXML.", "Import complete", 0)
