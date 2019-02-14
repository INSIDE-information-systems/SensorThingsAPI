# Intro

In order to assure that the Fraunhofer FROST implementation together with the underlying PostgreSQL DB meet BRGM's performance requirements, further benchmarking activities are being undertaken. For this purpose, the French Fairy DB has been transformed to the requirements of FROST, and creative queries are being formulated to mimic the spectrum of real-world requirements and thus gauge system response times.

# SQL
For the transformation of the Fairy Data to the FROST database structures, materialized views were created. 
A first set of base views were created for features requiring complex join structures. Based on these as required, materialized views were created for the basic FROST database tables. The content of these views was then copied to the tables from a FROST deployment, whereby the data was reindexed to remove the string values coming from some of the referenced codes in the source data (the views rely on a concatenation of code strings as ids).




