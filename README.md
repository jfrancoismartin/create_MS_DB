# create_MS_DB
Set of R script to create MS1 txt files and Rdata Files from inhouse xlsx files and public DB (HMDB, CHEBI).
The resulting files are used to be matched with an xcms or MS-Dial peaklist.

1- create_DB_StandardAXIOM.R
Create a Rdata files and a text files for each ionisation mode using a xlsx files of annotated standards spectra obtained with Waters QTOF. 
With the same standarts analysed on an Orbitrap XL, create also a RData and text files using a list of monoIsotopic m/z.
In that case the script generate a list of putative adducts fragments and isotopes. This is done for both ionisation mode.

2- creaDatabaseContaminants_Isopat.R
This script generate a list of m/z corresponding to an inhouse DB of contaminants, pesticides and xenobiotic. 
The script use the Envipat package to generate for each formula of the compounds 
a list of potential Fragments adducts with their isotopes. This is done for both ionisation mode.

3- XML_HMDB_import.R
Script able to parse the xml HMDB files of compounds(all+serum+urines+feces)
Then generates a RData and text files of monoisotopic mass for matching.

4- CHEBI_import.R
Script able to collect compound information for the different CHEBI files available for download
Then generates a RData and text files of monoisotopic mass for matching.