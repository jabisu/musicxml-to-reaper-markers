# musicxml-to-reaper-markers

## 🎼 Usage

This script helps you import section markers into REAPER from a **Guitar Pro 8** project using a **MusicXML file**. It is designed to work with a dedicated metronome track named **"Claca"**, which must be exported separately in MIDI format.

---

### 🛠 Installation  

1. **Download the script**  
   - Download `musicxmlSections2ReaperMarkers.lua` and save it in REAPER’s **Scripts directory**.  
   - To find this directory, open REAPER and go to:  
     ```
     Options → Show REAPER resource path in Explorer/Finder
     ```
   - Inside the resource folder, place the script in:  
     ```
     /Scripts/
     ```

2. **Load the script into REAPER**  
   - Open REAPER and go to:  
     ```
     Actions → Show action list...
     ```
   - Click **New Action** → **Load ReaScript...**  
   - Select `musicxmlSections2ReaperMarkers.lua` and add it to the action list.  

---

### 🎵 Exporting from Guitar Pro 8  

1. **Prepare the Guitar Pro 8 project**  
   - Make sure the project contains a track named **"Claca"** with the metronome data.  

2. **Export the necessary files**  
   - **Export the "Claca" track as a MIDI file** (only this track).  
   - **Export the entire project as a MusicXML file**.  

---

### 🎛 Importing into REAPER  

1. **Import the MIDI track**  
   - Drag and drop the **MIDI file** (Claca track) into an empty track in REAPER at the very start of the project.  
   - When prompted, choose **Import tempo map** to sync the project’s tempo.  

2. **Run the script**  
   - Open **Actions → Show action list...**  
   - Search for `musicxmlSections2ReaperMarkers` and run the script.  
   - Select the **MusicXML file** when prompted.  

📌 **The script will automatically create markers based on the section names from the MusicXML file.**  

---

## 💖 Support this project  
This script is completely free and open source. If you found it useful and want to thank me, you can make a donation via PayPal:

[![Donar con PayPal](https://www.paypal.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/donate/?business=BQPMX5NRR67T2&no_recurring=1&item_name=Thanks+for+the+script%21&currency_code=EUR)  
