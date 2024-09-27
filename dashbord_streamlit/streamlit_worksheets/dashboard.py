import streamlit as st
from connect_data_wh import query_job_listing
from datetime import datetime
import pandas as pd
import numpy as np

def layout():
    df = query_job_listing()
    max_date = df["PUBLISHED"].max().date()
    formatted_max_date = datetime.strftime(max_date, '%A, %B %d, %Y')

    engineer_types = ["All"] + sorted(df["ENGINEER_TYPE"].unique().tolist())
    st.title(f":blue[Engineer Job Listings]")
    st.write(f"Job listings for engineers from Arbetsförmedlingen's API as of {formatted_max_date}")


    cols = st.columns(1)
    st.markdown(f"## :blue[Vacancies]")
    with cols[0]:
        selected_engineer_type = st.selectbox("Filter by Engineer Type", engineer_types)

    where_clauses = []

    if selected_engineer_type != "All":
        where_clauses.append(f"ENGINEER_TYPE = '{selected_engineer_type}'")
    where_clause = "WHERE " + " AND ".join(where_clauses) if where_clauses else ""
    filtered_df = query_job_listing(f"SELECT * FROM mart_job_listings {where_clause}")

    cols = st.columns(3)
    with cols[0]:
        st.metric(label="Total", value=filtered_df["VACANCIES"].sum())
    with cols[1]:
        st.metric(label="In Stockholm", value=filtered_df.query("WORKPLACE_CITY == 'Stockholm'")["VACANCIES"].sum())
    with cols[2]:
        st.metric(label="In Göteborg", value=filtered_df.query("WORKPLACE_CITY == 'Göteborg'")["VACANCIES"].sum())

# Filtering option
    where_clause = f"WHERE ENGINEER_TYPE = '{selected_engineer_type}'" if selected_engineer_type != "All" else ""

    st.markdown("## :blue[Job listings for engineers over time]")

    # Query for all vacancies
    vacancies_per_date_df = query_job_listing(f"""
            SELECT
                SUM(vacancies) as vacancies,
                DATE(published) as date_published  -- Convert timestamp to date
            FROM
                mart_job_listings
            GROUP BY
                date_published
            ORDER BY vacancies DESC;                    
            """)

    vacancies_per_date_filtered_df = query_job_listing(f"""
            SELECT
                SUM(vacancies) as vacancies,
                DATE(published) as date_published
            FROM
                mart_job_listings 
                {where_clause}
            GROUP BY
                date_published
            ORDER BY vacancies DESC;
            """)

    combined_df = pd.merge(vacancies_per_date_df, vacancies_per_date_filtered_df, 
                        on='DATE_PUBLISHED', how='left', suffixes=('_all', '_filtered'))
    
    combined_df['VACANCIES_filtered'] = combined_df['VACANCIES_filtered'].fillna(0)  # Fill missing filtered vacancies with 0


    combined_df['All vacancies'] = combined_df['VACANCIES_all']

    combined_df.drop(columns=['VACANCIES_all'], inplace=True)

    combined_df.rename(columns={
        'VACANCIES_filtered': 'Chosen engineer type'  # Renamed from _filtered suffix
    }, inplace=True)

    combined_df.set_index('DATE_PUBLISHED', inplace=True)


    st.line_chart(data=combined_df, x_label='Date published' , y_label="Vacancies")


    cols = st.columns(1)
   
    with cols[0]:
        st.markdown("### :blue[Ten Largest Employers]")
        st.bar_chart(
            query_job_listing(
                f"""
                SELECT
                    SUM(vacancies) as vacancies,
                    employer_name AS Employer
                FROM
                    mart_job_listings
                {where_clause}
                GROUP BY
                    employer_name
                ORDER BY vacancies DESC
                LIMIT 10;
                """
            ),
            x="EMPLOYER",
            y="VACANCIES",
        )

    cols=st.columns(2)

    with cols[0]:
        st.markdown("### :blue[By Municipality]")
        st.dataframe(
            query_job_listing(
                f"""
                SELECT
                    SUM(vacancies) as vacancies,
                    workplace_municipality
                FROM
                    mart_job_listings
                {where_clause}
                GROUP BY
                    workplace_municipality
                ORDER BY vacancies DESC;
                """
            ), hide_index=True
        )


    with cols[1]:
        st.markdown("### :blue[By Region]")
        st.dataframe(
            query_job_listing(
                f"""
                SELECT
                    SUM(vacancies) as vacancies,
                    workplace_region
                FROM
                    mart_job_listings
                {where_clause}
                GROUP BY
                    workplace_region
                ORDER BY vacancies DESC;
                """
            ), hide_index=True
        )

    st.markdown("## :blue[Find Advertisement]")

    cols =st.columns(2)

    with cols[0]:
        selected_company = st.selectbox("Select an employer", filtered_df["EMPLOYER_NAME"].unique())

    with cols[1]:
        selected_headline = st.selectbox(
            "Select an advertisement",
            filtered_df.query("EMPLOYER_NAME == @selected_company")["HEADLINE"],
            )
    

    st.markdown("### :blue[Job ad]")
    st.markdown(
        df.query("HEADLINE == @selected_headline and EMPLOYER_NAME == @selected_company"
        )["DESCRIPTION_TEXT"].values[0], 
        unsafe_allow_html=True,
    )
    
    st.markdown("## :blue[Engineer Type Ad Density]")
    cols = st.columns(1)
    with cols[0]:
        st.dataframe(
            query_job_listing(
                f"""
                SELECT
                    SUM(vacancies) as vacancies,
                    engineer_type
                FROM
                    mart_job_listings
                GROUP BY
                    engineer_type
                ORDER BY vacancies DESC;
                """
            ), hide_index=True
        )
if __name__ == "__main__":
    layout()