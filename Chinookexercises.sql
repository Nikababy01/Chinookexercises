--non_usa_customers.sql
Select c.CustomerId, c.FirstName + ' ' + c.LastName as FullName, c.Country
from Customer c
where c.Country <> 'USA'
order by c.Country;

--brazil_customers.sql
Select c.CustomerId, c.FirstName + ' ' + c.LastName as FullName, c.Country
from Customer c
where c.Country = 'Brazil'
order by c.Country;

--brazil_customers.sql
Select c.CustomerId, c.FirstName + ' ' + c.LastName as FullName, i.InvoiceId, i.InvoiceDate, i.BillingCountry
from Customer c
join invoice i
ON i.CustomerId = c.CustomerId
where c.Country = 'Brazil'

--sales_agents.sql
Select*
from Employee
where Title = 'Sales Support Agent'

--unique_invoice_countries.sql
Select Distinct(i.BillingCountry)
from Invoice i
 order by BillingCountry asc

--sales_agent_invoices.sql
Select c.SupportRepId as SalesAgentId, e.FirstName + ' ' + e.LastName as SalesRepName, i.InvoiceId
From Customer c
Join Invoice i
On c.CustomerId = i.CustomerId
Left Join Employee e
On e.EmployeeId = c.SupportRepId

--invoice_totals.sql

Select  c.FirstName + ' ' + c.LastName as CustomerName, c.Country,
e.FirstName + ' ' + e.LastName as AgentName,i.InvoiceId, i.Total
From Customer c
Join Invoice i
On c.CustomerId = i.CustomerId
Left Join Employee e
On e.EmployeeId = c.SupportRepId
order by c.Country, CustomerName, i.InvoiceId

--total_invoices_year.sql
Select Count (*) as TotalInvoices, Year(i.InvoiceDate) as YearOfCount
From Invoice i
Where Year(i.InvoiceDate)=2009 or Year(i.Invoicedate)=2011
group by Year(i.InvoiceDate)


-- total_sales_year.sql
select sum(i.Total) as TotalSales, Year(i.InvoiceDate) as YearOfTotal
from Invoice i
where Year(i.InvoiceDate) = 2009 or Year(i.InvoiceDate) = 2011
group by Year(i.InvoiceDate)

-- total_sales_year.sql
select count(*) as TotalLines
from InvoiceLine
where InvoiceId= 37

-- line_items_per_invoice.sql
select InvoiceId, count(*) as TotalLines
from InvoiceLine
group by InvoiceId

--line_item_track_artist.sql
Select
t1.Name as TrackName, a2.Name as ArtistName, i1.InvoiceLineId, i1.TrackId
from Album a1
join Artist a2
on a2.ArtistId = a1.ArtistId
join track t1 on t1.AlbumId= a1.AlbumId
join InvoiceLine i1 on i1.TrackId= t1.TrackId
order by a2.Name

--country_invoices.sql
Select i.BillingCountry, Count(InvoiceId)as InvoiceCnt
from invoice i
group by BillingCountry
order by InvoiceCnt desc

--playlist_track_count.sql
select p.PlaylistId, p.Name, count(p1.TrackId)as TotalTracks
from Playlist p
join PlaylistTrack p1
on p1.PlaylistId= p.PlaylistId
group by p.PlaylistId,p.Name
order by TotalTracks desc

--tracks_no_id.sql
Select
t1.Name as TrackName, m.Name as MediaType, g.Name as Genre
from Album a1
join track t1 on t1.AlbumId= a1.AlbumId
join MediaType m on m.MediaTypeId= t1.MediaTypeId
join Genre g on g.GenreId= t1.GenreId
order by Genre,MediaType asc

--invoice_line_item_count.sql
select i2.InvoiceId, count(i1.InvoiceId) as TotalLineItems
from Invoice i1
join InvoiceLine i2 on i1.InvoiceId = i2.InvoiceId
group by i2.InvoiceId
order by TotalLineItems desc

--sales_agent_total_sales.sql
with Agent_sales AS (
select 
cs.CustomerId as Customer, e.EmployeeId, SupportRepId as Agent, e.FirstName + ', ' + e.LastName as AgentName
From Customer cs
join Employee e
on e.EmployeeId  = cs.SupportRepId
)
Select AgentName, sum(iv.Total)as AgentTotalSale
from Agent_sales a
join Invoice iv
on iv.CustomerId = Customer
group by AgentName

--top_2009_agent.sql
with Agent_sales AS (
select Year(iv.InvoiceDate) as InvoiceYear,
e.LastName + ', ' + e.FirstName as AgentName, sum(iv.total) as TotalSales
From Customer cs
join Employee e
on e.EmployeeId  = cs.SupportRepId
join Invoice iv
on iv.CustomerId = cs.CustomerId
group by  e.FirstName, e.LastName, Year(iv.InvoiceDate)
)

Select Top 1(AgentName), TotalSales
from Agent_sales 
where InvoiceYear = '2009'
order by TotalSales desc

--Top agent.sql
with Agent_sales AS (
select 
cs.CustomerId as Customer, e.EmployeeId, SupportRepId as Agent, e.FirstName + ', ' + e.LastName as AgentName
From Customer cs
join Employee e
on e.EmployeeId  = cs.SupportRepId
)
Select Top 1 (AgentName), sum(iv.Total)as AgentTotalSale
from Agent_sales a
join Invoice iv
on iv.CustomerId = Customer
group by AgentName
order by AgentTotalSale desc

--sales_agent_customer_count.sql
with Agent_sales AS (
select 
cs.CustomerId as Customer, e.EmployeeId, SupportRepId as Agent, e.FirstName + ' ' + e.LastName as AgentName
From Customer cs
join Employee e
on e.EmployeeId  = cs.SupportRepId
)
Select  AgentName, count(Customer)as TotalCustomers
from Agent_sales
group by AgentName

--sales_per_country.sql
Select i.BillingCountry, sum(i.Total) as TotalSales
from invoice i
group by BillingCountry
order by TotalSales desc

--top_country.sql
with CountrySales AS
(
Select i.BillingCountry as Country, sum(i.Total) as TotalSales
from invoice i
group by BillingCountry

)
Select Top 1 (Country), TotalSales
from CountrySales
group by Country,TotalSales 
order by TotalSales desc

--top_2013_track.sql –go back and add the quantity
select  i2.TrackId, Year(i1.InvoiceDate), count(i2.TrackId) as TotalPurchased 
from Invoice i1
join InvoiceLine i2
on i1.InvoiceId = i2.InvoiceId
where Year(i1.InvoiceDate) = 2013
group by  i2.TrackId, Year(i1.InvoiceDate)
order by TotalPurchased desc

--top 5_tracks  go back and add the quantity
select Top 5 (i2.TrackId), t.Name as Songs, count(i2.TrackId) as TotalPurchased 
from Invoice i1
join InvoiceLine i2
on i1.InvoiceId = i2.InvoiceId
join Track t
on t.TrackId = i2.TrackId
group by  i2.TrackId, t.Name
order by TotalPurchased desc

--top_3 artist.sql

select Top 3 (a2.Name), sum(i2.Total) as Total, a2.Name as ArtistName
from Album a1
join Artist a2
on a1.ArtistId = a2.ArtistId
join Track t1
on t1.AlbumId = a1.AlbumId
join InvoiceLine i1
on i1.TrackId = t1.TrackId
join Invoice i2
on i2.InvoiceId= i1.InvoiceId
group by a2.Name
order by Total desc

--top_media_type.sql
select  sum(i2.Total) as Total, m1.Name as MediaName
from Track t1
join InvoiceLine i1
on i1.TrackId = t1.TrackId
join MediaType m1
on m1.MediaTypeId = t1.MediaTypeId
join Invoice i2
on i2.InvoiceId= i1.InvoiceId
group by m1.Name
order by Total desc

--or
select Top 1(m1.Name)as MediaName, sum(i2.Total) as Total 
from Track t1
join InvoiceLine i1
on i1.TrackId = t1.TrackId
join MediaType m1
on m1.MediaTypeId = t1.MediaTypeId
join Invoice i2
on i2.InvoiceId= i1.InvoiceId
group by m1.Name
order by Total desc
